import 'package:forecast_app/core/services/betting_parser_service.dart';

void main() async {
  print('🔍 Тестирование парсера 1xbet...\n');

  final parser = BettingParserService();

  // Проверяем доступность сайта
  print('Проверка доступности 1xbet...');
  final isAvailable = await parser.checkAvailability();
  print('✅ Сайт ${isAvailable ? "доступен" : "недоступен"}\n');

  if (!isAvailable) {
    print('❌ Невозможно продолжить тестирование');
    return;
  }

  // Парсим матчи
  print('Парсинг матчей...');
  final matches = await parser.parseMatches();

  print('\n📊 Результаты парсинга:');
  print('Найдено матчей: ${matches.length}');

  if (matches.isEmpty) {
    print('❌ Матчи не найдены. Возможно, структура страницы изменилась.');
    return;
  }

  print('\n📋 Список матчей:');
  for (var i = 0; i < matches.length && i < 10; i++) {
    final match = matches[i];
    print('${i + 1}. ${match.homeTeam} vs ${match.awayTeam}');
    print('   Счёт: ${match.homeScore}:${match.awayScore}');
    print('   Турнир: ${match.tournament}');
    print('   Дата: ${match.date}');
    print('');
  }

  if (matches.length > 10) {
    print('... и ещё ${matches.length - 10} матчей');
  }

  print('\n✅ Парсинг завершён успешно!');
}
