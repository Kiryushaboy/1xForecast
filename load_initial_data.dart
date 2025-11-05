import 'package:forecast_app/core/services/betting_parser_service.dart';
import 'package:forecast_app/core/services/match_cache_service.dart';

void main() async {
  print('🚀 Загрузка реальных данных с 1xbet...\n');

  // Инициализируем сервисы
  final parser = BettingParserService();
  final cacheService = MatchCacheService();
  await cacheService.initialize();

  print('✅ Сервисы инициализированы\n');

  // Парсим матчи
  print('🔄 Парсинг матчей с 1xbet...');
  final matches = await parser.parseMatches();

  if (matches.isEmpty) {
    print('❌ Не удалось загрузить матчи');
    await cacheService.dispose();
    return;
  }

  print('✅ Загружено ${matches.length} матчей\n');

  // Сохраняем в кеш
  print('💾 Сохранение в кеш...');
  await cacheService.cacheMatches(matches);

  print('✅ Данные успешно сохранены в кеш\n');

  // Проверяем сохраненные данные
  print('🔍 Проверка сохраненных данных...');
  final cachedMatches = await cacheService.getCachedMatches();
  print('✅ В кеше ${cachedMatches.length} матчей\n');

  // Показываем список
  print('📋 Сохраненные матчи:');
  for (var i = 0; i < cachedMatches.length; i++) {
    final match = cachedMatches[i];
    print('${i + 1}. ${match.homeTeam} vs ${match.awayTeam}');
  }

  print(
      '\n✨ Готово! Теперь приложение будет загружать эти данные при запуске.');
  print('📅 Следующее автоматическое обновление через 12 часов.');

  // Закрываем сервисы
  await cacheService.dispose();
}
