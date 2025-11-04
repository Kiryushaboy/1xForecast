import 'package:logger/logger.dart';
import '../../../matches/domain/entities/match.dart';

class BetParserService {
  final Logger _logger;

  BetParserService({Logger? logger}) : _logger = logger ?? Logger();

  /// Fetch matches from 1xbet API (placeholder - not implemented)
  Future<List<Match>> fetchMatches() async {
    _logger.i('Fetching matches from API...');

    // TODO: Implement actual API fetching logic
    // For now, return test data
    return _generateTestData();
  }

  List<Match> _generateTestData() {
    final now = DateTime.now();
    final matches = <Match>[];

    // Список топовых команд АПЛ (уменьшено для тестирования)
    final teams = [
      'Ливерпуль',
      'Манчестер Сити',
      'Арсенал',
      'Челси',
      'Тоттенхэм',
      'Манчестер Юнайтед',
      'Ньюкасл',
      'Астон Вилла',
    ];

    // Генерируем матчи за последние 30 дней
    const daysToGenerate = 30;
    int matchId = 0;

    // Генерируем матчи для каждой пары команд
    for (int i = 0; i < teams.length; i++) {
      for (int j = i + 1; j < teams.length; j++) {
        final homeTeam = teams[i];
        final awayTeam = teams[j];

        // Генерируем 3-5 матчей для каждой пары (минимум данных для статистики)
        final matchCount = 3 + (i + j) % 3;

        for (int k = 0; k < matchCount; k++) {
          // Распределяем матчи равномерно по дням (в пределах 30 дней)
          final dayOffset = (matchId * 7) % daysToGenerate;

          // Генерируем реалистичные счета (обычно 4-12 голов в сумме для 4x4)
          final homeScore = 4 + (i + j + k) % 6;
          final awayScore = 4 + (i * j + k) % 6;

          matches.add(Match(
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            homeScore: homeScore,
            awayScore: awayScore,
            date: now.subtract(Duration(days: dayOffset, hours: k * 2)),
            tournament: 'FIFA FC24 4x4 Английская Премьер Лига',
          ));

          matchId++;

          // Обратный матч (гости дома) - генерируем для половины пар
          if (k % 2 == 0) {
            final reverseDayOffset = ((matchId + 3) * 7) % daysToGenerate;
            matches.add(Match(
              homeTeam: awayTeam,
              awayTeam: homeTeam,
              homeScore: 5 + (j + i + k) % 5,
              awayScore: 5 + (j * i + k) % 5,
              date: now
                  .subtract(Duration(days: reverseDayOffset, hours: k * 2 + 1)),
              tournament: 'FIFA FC24 4x4 Английская Премьер Лига',
            ));
            matchId++;
          }
        }
      }
    }

    _logger.i(
        'Generated ${matches.length} test matches for ${teams.length} teams over last $daysToGenerate days');
    return matches;
  }
}
