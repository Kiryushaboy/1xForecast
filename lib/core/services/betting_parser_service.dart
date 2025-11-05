import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../../../features/matches/domain/entities/match.dart';
import 'package:logger/logger.dart';

/// Сервис для парсинга данных с 1xbet
class BettingParserService {
  final Dio _dio;
  final Logger _logger = Logger();

  BettingParserService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              headers: {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
              },
              validateStatus: (status) => status! < 500,
            ));

  /// Парсит матчи FIFA FC24 4x4 с 1xbet
  Future<List<Match>> parseMatches() async {
    try {
      print('🔍 BettingParser: Начинаем парсинг матчей с 1xbet...');
      _logger.i('Начинаем парсинг матчей с 1xbet...');

      const url =
          'https://1x-probet.com/ru/cyber/virtual/fifa/2648573-fc-24-4x4-england-championship';

      print('🌐 BettingParser: Загружаем страницу: $url');
      final response = await _dio.get(url);

      print('📡 BettingParser: Статус ответа: ${response.statusCode}');
      if (response.statusCode != 200) {
        print(
            '❌ BettingParser: Ошибка загрузки страницы: ${response.statusCode}');
        _logger.e('Ошибка загрузки страницы: ${response.statusCode}');
        return [];
      }

      // Парсим HTML
      print('📄 BettingParser: Парсим HTML...');
      final document = html_parser.parse(response.data);

      final matches = <Match>[];

      // Ищем все ссылки на матчи (исключаем ссылки с текстом "Перейти")
      final allLinks = document.querySelectorAll('a[href*="/live/"]');
      print('🔗 BettingParser: Найдено ${allLinks.length} ссылок с /live/');

      final matchLinks = allLinks.where((link) {
        final text = link.text.trim();
        return text.isNotEmpty &&
            !text.contains('Перейти') &&
            !text.contains('на страницу');
      }).toList();

      print(
          '✅ BettingParser: Отфильтровано ${matchLinks.length} ссылок на матчи');

      for (var link in matchLinks) {
        try {
          final href = link.attributes['href'];
          if (href == null || !href.contains('/live/')) continue;

          // Извлекаем названия команд из URL
          // Формат: /live/668327437-bernli-liverpul
          final urlParts = href.split('/');
          final matchSlug = urlParts.last; // "668327437-bernli-liverpul"

          // Удаляем ID матча в начале (цифры до первого тире)
          final slugWithoutId = matchSlug.replaceFirst(RegExp(r'^\d+-'), '');

          // Разбиваем на части по тире
          final slugParts = slugWithoutId.split('-');

          if (slugParts.length < 2) continue;

          // Находим середину - это граница между командами
          // Обычно формат: "team1-part1-part2-team2-part1-part2"
          // Пробуем разные варианты разбиения
          String? homeTeam;
          String? awayTeam;

          // Ищем самую длинную известную команду в начале
          for (var i = slugParts.length; i > 0; i--) {
            final potentialHome = slugParts.sublist(0, i).join(' ');
            final normalized = _normalizeTeamName(potentialHome);

            if (normalized != _capitalizeWords(potentialHome)) {
              // Нашли известную команду
              homeTeam = normalized;
              awayTeam = _normalizeTeamName(slugParts.sublist(i).join(' '));
              break;
            }
          }

          // Если не нашли, делим пополам
          if (homeTeam == null || awayTeam == null) {
            final midPoint = slugParts.length ~/ 2;
            homeTeam =
                _normalizeTeamName(slugParts.sublist(0, midPoint).join(' '));
            awayTeam =
                _normalizeTeamName(slugParts.sublist(midPoint).join(' '));
          }

          matches.add(Match(
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            homeScore: 0,
            awayScore: 0,
            date: DateTime.now(),
            tournament: 'FC 24. 4x4. Чемпионат Англии',
          ));

          print('⚽ BettingParser: Найден матч: $homeTeam vs $awayTeam');
          _logger
              .d('Найден матч: $homeTeam vs $awayTeam (slug: $slugWithoutId)');
        } catch (e) {
          print('⚠️ BettingParser: Ошибка парсинга матча - $e');
          _logger.w('Ошибка парсинга матча из ссылки', error: e);
          continue;
        }
      }

      print('✅ BettingParser: Успешно распарсено ${matches.length} матчей');
      _logger.i('Успешно распарсено ${matches.length} матчей');

      // ВРЕМЕННЫЙ FALLBACK: если парсер ничего не нашёл, возвращаем тестовые данные
      if (matches.isEmpty) {
        print(
            '⚠️ BettingParser: Парсер вернул 0 матчей, используем тестовые данные');
        return _getTestMatches();
      }

      return matches;
    } catch (e, stackTrace) {
      print('❌ BettingParser: Критическая ошибка - $e');
      print('Stack trace: $stackTrace');
      _logger.e('Ошибка парсинга матчей', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Нормализует название команды из URL-slug
  String _normalizeTeamName(String slug) {
    // Словарь для замены транслита (английские клубы АПЛ)
    final Map<String, String> translitMap = {
      // Частые команды
      'bernli': 'Бернли',
      'liverpul': 'Ливерпуль',
      'manchester yunayted': 'Манчестер Юнайтед',
      'manchester siti': 'Манчестер Сити',
      'arsenal': 'Арсенал',
      'chelsea': 'Челси',
      'tottenham': 'Тоттенхэм',
      'vest hem yunayted': 'Вест Хэм Юнайтед',
      'vest hem': 'Вест Хэм',
      'luton taun': 'Лутон Таун',
      'fulhem': 'Фулхэм',
      'nottingem forest': 'Ноттингем Форест',
      'brayton end hav albion': 'Брайтон',
      'brayton': 'Брайтон',
      'bornmut': 'Борнмут',
      'everton': 'Эвертон',
      'sheffild yunayted': 'Шеффилд Юнайтед',
      'sheffild': 'Шеффилд Юнайтед',
      'kristal pelas': 'Кристал Пэлас',
      'aston villa': 'Астон Вилла',
      'nyukasl yunayted': 'Ньюкасл Юнайтед',
      'nyukasl': 'Ньюкасл',
      'vulverhempton': 'Вулверхэмптон',
      'leeds yunayted': 'Лидс Юнайтед',
      'lester siti': 'Лестер Сити',
      'sauthempton': 'Саутгемптон',
      'uotford': 'Уотфорд',
      'bourn': 'Борнмут',

      // Частичные совпадения для составных названий
      'yunayted': 'Юнайтед',
      'siti': 'Сити',
      'taun': 'Таун',
      'forest': 'Форест',
    };

    final normalized = slug.trim().toLowerCase();

    // Проверяем точное совпадение
    if (translitMap.containsKey(normalized)) {
      return translitMap[normalized]!;
    }

    // Проверяем частичные совпадения для составных названий
    for (var entry in translitMap.entries) {
      if (normalized.contains(entry.key)) {
        return translitMap[normalized] ?? _capitalizeWords(slug);
      }
    }

    return _capitalizeWords(slug);
  }

  /// Делает первую букву каждого слова заглавной
  String _capitalizeWords(String text) {
    return text
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  /// Парсит URL логотипа команды с 1xbet
  Future<String?> parseTeamLogoUrl(String teamName) async {
    try {
      // TODO: Реализовать парсинг логотипов команд
      // Можно искать по названию команды на странице матча
      return null;
    } catch (e) {
      _logger.e('Ошибка парсинга логотипа для $teamName', error: e);
      return null;
    }
  }

  /// Парсит детальную информацию о матче (счет, время и т.д.)
  Future<Match?> parseMatchDetails(String matchUrl) async {
    try {
      final response = await _dio.get(matchUrl);

      if (response.statusCode != 200) {
        _logger.e('Ошибка загрузки страницы матча: ${response.statusCode}');
        return null;
      }

      final document = html_parser.parse(response.data);

      // Извлекаем названия команд из заголовка
      final titleElement = document.querySelector('title');
      if (titleElement == null) return null;

      final title = titleElement.text;
      final teamsMatch =
          RegExp(r'(.*?)\s*-\s*(.*?)(?:\s*\||\s*$)').firstMatch(title);

      if (teamsMatch == null) return null;

      final homeTeam = teamsMatch.group(1)?.trim() ?? '';
      final awayTeam = teamsMatch.group(2)?.trim() ?? '';

      // Пытаемся найти счет (если матч идет или завершен)
      int homeScore = 0;
      int awayScore = 0;

      // Можно добавить парсинг счета из HTML, если он доступен
      // TODO: Реализовать парсинг счета, когда найдем соответствующий селектор

      return Match(
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        homeScore: homeScore,
        awayScore: awayScore,
        date: DateTime.now(),
        tournament: 'FC 24. 4x4. Чемпионат Англии',
      );
    } catch (e, stackTrace) {
      _logger.e('Ошибка парсинга деталей матча',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Проверяет доступность 1xbet
  Future<bool> checkAvailability() async {
    try {
      final response = await _dio
          .get('https://1x-probet.com')
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      _logger.w('1xbet недоступен', error: e);
      return false;
    }
  }

  /// ВРЕМЕННЫЕ тестовые данные на случай, если парсер не работает
  List<Match> _getTestMatches() {
    return [
      Match(
        homeTeam: 'Манчестер Сити',
        awayTeam: 'Ливерпуль',
        homeScore: 0,
        awayScore: 0,
        date: DateTime.now(),
        tournament: 'FC 24. 4x4. Чемпионат Англии',
      ),
      Match(
        homeTeam: 'Челси',
        awayTeam: 'Арсенал',
        homeScore: 0,
        awayScore: 0,
        date: DateTime.now(),
        tournament: 'FC 24. 4x4. Чемпионат Англии',
      ),
      Match(
        homeTeam: 'Манчестер Юнайтед',
        awayTeam: 'Тоттенхэм',
        homeScore: 0,
        awayScore: 0,
        date: DateTime.now(),
        tournament: 'FC 24. 4x4. Чемпионат Англии',
      ),
      Match(
        homeTeam: 'Вест Хэм',
        awayTeam: 'Эвертон',
        homeScore: 0,
        awayScore: 0,
        date: DateTime.now(),
        tournament: 'FC 24. 4x4. Чемпионат Англии',
      ),
      Match(
        homeTeam: 'Ньюкасл',
        awayTeam: 'Брайтон',
        homeScore: 0,
        awayScore: 0,
        date: DateTime.now(),
        tournament: 'FC 24. 4x4. Чемпионат Англии',
      ),
    ];
  }
}
