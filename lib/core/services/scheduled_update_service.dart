import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../../../features/matches/domain/entities/match.dart';
import 'betting_parser_service.dart';

/// Сервис для управления автоматическим обновлением данных каждые 12 часов
class ScheduledUpdateService {
  final BettingParserService _parserService;
  final Logger _logger = Logger();

  Timer? _updateTimer;
  static const String _lastUpdateKey = 'last_update_timestamp';
  static const Duration _updateInterval = Duration(hours: 12);

  // Callback для сохранения распарсенных данных
  final Future<void> Function(List<Match> matches)? onDataParsed;

  ScheduledUpdateService({
    BettingParserService? parserService,
    this.onDataParsed,
  }) : _parserService = parserService ?? BettingParserService();

  /// Инициализирует сервис и запускает таймер
  Future<void> initialize() async {
    _logger.i('Инициализация ScheduledUpdateService...');

    // Проверяем, нужно ли обновление при запуске
    final shouldUpdate = await _shouldUpdateOnStartup();

    if (shouldUpdate) {
      _logger.i(
          'Прошло более 12 часов с последнего обновления. Запускаем парсинг...');
      await updateData();
    } else {
      _logger.i('Данные актуальны, обновление не требуется.');
    }

    // Запускаем периодический таймер
    _startPeriodicUpdates();
  }

  /// Проверяет, нужно ли обновление при запуске приложения
  Future<bool> _shouldUpdateOnStartup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdateTimestamp = prefs.getInt(_lastUpdateKey);

      if (lastUpdateTimestamp == null) {
        _logger.i('Первый запуск - требуется обновление');
        return true;
      }

      final lastUpdate =
          DateTime.fromMillisecondsSinceEpoch(lastUpdateTimestamp);
      final now = DateTime.now();
      final difference = now.difference(lastUpdate);

      _logger.d('Последнее обновление: $lastUpdate');
      _logger.d('Прошло времени: ${difference.inHours} часов');

      return difference >= _updateInterval;
    } catch (e) {
      _logger.e('Ошибка проверки времени последнего обновления', error: e);
      return true; // В случае ошибки делаем обновление
    }
  }

  /// Запускает периодический таймер обновления
  void _startPeriodicUpdates() {
    _logger.i('Запуск периодического таймера обновления (каждые 12 часов)');

    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(_updateInterval, (timer) {
      _logger.i('Сработал таймер обновления. Запускаем парсинг...');
      updateData();
    });
  }

  /// Обновляет данные (ручной вызов или по таймеру)
  Future<List<Match>> updateData() async {
    try {
      _logger.i('Начинаем обновление данных...');

      // Парсим матчи с 1xbet
      final matches = await _parserService.parseMatches();

      if (matches.isEmpty) {
        _logger.w('Не удалось распарсить матчи. Данные не будут обновлены.');
        return [];
      }

      // Сохраняем время обновления
      await _saveUpdateTimestamp();

      // Вызываем callback для сохранения данных
      if (onDataParsed != null) {
        await onDataParsed!(matches);
        _logger.i(
            'Данные успешно обновлены и сохранены (${matches.length} матчей)');
      }

      return matches;
    } catch (e, stackTrace) {
      _logger.e('Ошибка обновления данных', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Сохраняет временную метку последнего обновления
  Future<void> _saveUpdateTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_lastUpdateKey, now);
      _logger.d('Сохранена метка времени обновления: ${DateTime.now()}');
    } catch (e) {
      _logger.e('Ошибка сохранения времени обновления', error: e);
    }
  }

  /// Получает время последнего обновления
  Future<DateTime?> getLastUpdateTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastUpdateKey);

      if (timestamp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      _logger.e('Ошибка получения времени последнего обновления', error: e);
      return null;
    }
  }

  /// Получает время до следующего обновления
  Future<Duration?> getTimeUntilNextUpdate() async {
    final lastUpdate = await getLastUpdateTime();
    if (lastUpdate == null) return null;

    final nextUpdate = lastUpdate.add(_updateInterval);
    final now = DateTime.now();

    if (nextUpdate.isBefore(now)) {
      return Duration.zero;
    }

    return nextUpdate.difference(now);
  }

  /// Останавливает таймер и освобождает ресурсы
  void dispose() {
    _logger.i('Остановка ScheduledUpdateService');
    _updateTimer?.cancel();
    _updateTimer = null;
  }
}
