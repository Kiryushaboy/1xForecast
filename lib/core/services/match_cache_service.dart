import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/matches/domain/entities/match.dart';

/// Сервис для кеширования матчей в Hive
class MatchCacheService {
  static const String _matchesBoxName = 'matches';
  static const String _lastUpdateKey = 'matches_last_update';

  final Logger _logger = Logger();
  Box<Map>? _matchesBox;

  /// Инициализирует Hive и открывает box для матчей
  Future<void> initialize() async {
    try {
      _logger.i('Инициализация MatchCacheService...');

      // Инициализируем Hive (если еще не инициализирован)
      if (!Hive.isBoxOpen(_matchesBoxName)) {
        await Hive.initFlutter();
      }

      // Открываем box для матчей
      _matchesBox = await Hive.openBox<Map>(_matchesBoxName);

      _logger.i('MatchCacheService успешно инициализирован');
    } catch (e, stackTrace) {
      _logger.e('Ошибка инициализации MatchCacheService',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Сохраняет список матчей в кеш
  Future<void> cacheMatches(List<Match> matches) async {
    try {
      if (_matchesBox == null) {
        _logger.w('Box не инициализирован. Вызовите initialize() сначала');
        return;
      }

      _logger.i('Сохранение ${matches.length} матчей в кеш...');

      // Очищаем старые данные
      await _matchesBox!.clear();

      // Сохраняем новые матчи
      for (var i = 0; i < matches.length; i++) {
        final matchJson = matches[i].toJson();
        await _matchesBox!.put(i, matchJson);
      }

      // Сохраняем время обновления
      await _saveLastUpdateTime();

      _logger.i('Матчи успешно сохранены в кеш');
    } catch (e, stackTrace) {
      _logger.e('Ошибка сохранения матчей в кеш',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Загружает матчи из кеша
  Future<List<Match>> getCachedMatches() async {
    try {
      if (_matchesBox == null) {
        _logger.w('Box не инициализирован. Вызовите initialize() сначала');
        return [];
      }

      if (_matchesBox!.isEmpty) {
        _logger.i('Кеш пуст');
        return [];
      }

      _logger.i('Загрузка матчей из кеша...');

      final matches = <Match>[];

      for (var matchJson in _matchesBox!.values) {
        try {
          // Преобразуем Map в Map<String, dynamic>
          final jsonMap = Map<String, dynamic>.from(matchJson);
          final match = Match.fromJson(jsonMap);
          matches.add(match);
        } catch (e) {
          _logger.w('Ошибка парсинга матча из кеша', error: e);
          continue;
        }
      }

      _logger.i('Загружено ${matches.length} матчей из кеша');
      return matches;
    } catch (e, stackTrace) {
      _logger.e('Ошибка загрузки матчей из кеша',
          error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Проверяет, есть ли матчи в кеше
  Future<bool> hasCachedMatches() async {
    if (_matchesBox == null) {
      await initialize();
    }
    return _matchesBox?.isNotEmpty ?? false;
  }

  /// Очищает кеш
  Future<void> clearCache() async {
    try {
      if (_matchesBox == null) {
        _logger.w('Box не инициализирован');
        return;
      }

      await _matchesBox!.clear();
      _logger.i('Кеш очищен');
    } catch (e) {
      _logger.e('Ошибка очистки кеша', error: e);
    }
  }

  /// Сохраняет время последнего обновления кеша
  Future<void> _saveLastUpdateTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      _logger.w('Ошибка сохранения времени обновления кеша', error: e);
    }
  }

  /// Получает время последнего обновления кеша
  Future<DateTime?> getLastUpdateTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastUpdateKey);

      if (timestamp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      _logger.w('Ошибка получения времени обновления кеша', error: e);
      return null;
    }
  }

  /// Получает количество закешированных матчей
  int getCachedMatchesCount() {
    return _matchesBox?.length ?? 0;
  }

  /// Закрывает box и освобождает ресурсы
  Future<void> dispose() async {
    try {
      await _matchesBox?.close();
      _matchesBox = null;
      _logger.i('MatchCacheService закрыт');
    } catch (e) {
      _logger.e('Ошибка закрытия MatchCacheService', error: e);
    }
  }
}
