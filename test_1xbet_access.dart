import 'package:dio/dio.dart';

void main() async {
  print('🧪 Тестирование доступности 1xbet...\n');

  final dio = Dio(BaseOptions(
    headers: {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    },
    validateStatus: (status) => status! < 500,
  ));

  const url =
      'https://1x-probet.com/ru/cyber/virtual/fifa/2648573-fc-24-4x4-england-championship';

  try {
    print('📡 Отправляем запрос на: $url');
    final response = await dio.get(url);

    print('✅ Статус: ${response.statusCode}');
    print('📦 Размер ответа: ${response.data.toString().length} байт');
    print('📄 Заголовки ответа:');
    response.headers.forEach((name, values) {
      print('  $name: ${values.join(", ")}');
    });

    // Проверяем наличие ключевых слов
    final html = response.data.toString();
    final hasLiveLinks = html.contains('/live/');
    final hasChampionship = html.contains('Чемпионат Англии');
    final hasFIFA = html.contains('FIFA');

    print('\n🔍 Анализ содержимого:');
    print('  Ссылки /live/: ${hasLiveLinks ? "✅ Найдены" : "❌ Не найдены"}');
    print(
        '  "Чемпионат Англии": ${hasChampionship ? "✅ Найден" : "❌ Не найден"}');
    print('  "FIFA": ${hasFIFA ? "✅ Найден" : "❌ Не найден"}');

    // Показываем первые 500 символов
    print('\n📝 Первые 500 символов ответа:');
    print(html.substring(0, html.length > 500 ? 500 : html.length));
  } catch (e, stackTrace) {
    print('❌ Ошибка: $e');
    print('Stack trace: $stackTrace');
  }
}
