# 1xForecast - FIFA FC24 4x4 Match Analysis

Приложение для анализа статистики матчей FIFA FC24 4x4 из 1xbet с акцентом на прогнозирование вероятности того, что обе команды забьют 6+ голов.

## 🏗️ Архитектура

Проект построен по принципам **Clean Architecture** с чёткой организацией по фичам:

```
lib/
├── core/                          # Общие компоненты
│   ├── constants/                 # Константы приложения
│   │   └── app_constants.dart     # Пороги для анализа
│   ├── utils/                     # Утилиты
│   │   └── helpers.dart           # ColorUtils, DateUtils
│   └── router/                    # Навигация
│       └── app_router.dart        # go_router конфигурация
│
├── features/                      # Фичи приложения
│   ├── matches/                   # Управление матчами
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── match_local_datasource.dart  # Hive storage
│   │   │   │   └── bet_parser_service.dart      # Парсинг/API
│   │   │   └── repositories/
│   │   │       └── match_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── match.dart                   # Модель матча
│   │   │   └── repositories/
│   │   │       └── match_repository.dart        # Интерфейс
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── home_page.dart               # Главная страница
│   │       └── providers/
│   │           └── match_providers.dart         # Riverpod providers
│   │
│   └── analysis/                  # Анализ противостояний
│       ├── domain/
│       │   ├── entities/
│       │   │   └── matchup_stats.dart           # Статистика
│       │   └── services/
│       │       └── matchup_analyzer.dart        # Логика анализа
│       └── presentation/
│           ├── pages/
│           │   └── matchup_analysis_page.dart   # Детальный анализ
│           └── providers/
│               └── analysis_providers.dart
│
└── main.dart                      # Точка входа
```

## 🚀 Технологический стек

### Основные зависимости
- **flutter_riverpod ^2.5.1** - State management (вместо setState)
- **go_router ^14.6.2** - Навигация между экранами
- **hive ^2.2.3** - Локальное хранилище
- **dio ^5.7.0** - HTTP клиент для API запросов
- **equatable ^2.0.5** - Сравнение объектов

### UI компоненты
- **fl_chart ^0.66.0** - Графики и визуализация
- **intl ^0.19.0** - Форматирование дат
- **logger ^2.4.0** - Логирование

### Утилиты
- **excel ^4.0.3** - Экспорт в Excel
- **shared_preferences ^2.2.2** - Простые настройки

## 📊 Ключевые возможности

### 1. Анализ "Обе забили 6+"
- Расчёт процента матчей, где обе команды забили 6+ голов
- Цветовая индикация:
  - 🟢 Зелёный: ≥70% (высокая вероятность)
  - 🟠 Оранжевый: 50-70% (средняя вероятность)
  - 🔴 Красный: <50% (низкая вероятность)

### 2. Статистика по сезонам
- Разбивка по сезонам (каждые 90 дней)
- Процент успеха для каждого сезона
- История изменения статистики

### 3. История матчей
- Полный список встреч команд
- Счёт каждого матча
- Отметка о выполнении условия "обе 6+"

## 🎯 Использование

### Запуск приложения
```bash
# Установка зависимостей
flutter pub get

# Запуск на веб
flutter run -d chrome

# Или на подключённом устройстве
flutter run
```

### Загрузка данных
1. Нажмите кнопку "Загрузить данные" на главном экране
2. В текущей версии загружаются тестовые данные
3. После загрузки отобразится список противостояний

### Просмотр анализа
1. Выберите противостояние из списка
2. Увидите:
   - Основной процент "обе забили 6+"
   - Статистику по сезонам
   - Историю всех матчей

## 🔧 Настройка

### Константы (lib/core/constants/app_constants.dart)
```dart
class AppConstants {
  static const int highScoringThreshold = 6;        // Порог "высокий счёт"
  static const double highProbabilityThreshold = 70.0;   // Зелёный
  static const double mediumProbabilityThreshold = 50.0;  // Оранжевый
  
  static const String matchesKey = 'fifa_matches_v1'; // Ключ Hive
  
  // TODO: Добавить настоящий API endpoint
  static const String apiBaseUrl = 'https://1xbet.com/api';
}
```

### Интеграция с 1xbet API
Обновите `lib/features/matches/data/datasources/bet_parser_service.dart`:
```dart
Future<List<Match>> fetchMatches() async {
  _logger.i('Fetching matches from API...');
  
  // TODO: Реализовать настоящий парсинг
  final response = await Dio().get('YOUR_API_ENDPOINT');
  // Парсинг HTML или JSON
  
  return _generateTestData(); // Заменить на реальные данные
}
```

## 📱 State Management (Riverpod)

### Providers
```dart
// Загрузка всех матчей
final allMatchesProvider = FutureProvider<List<Match>>;

// Статистика противостояния
final matchupStatsProvider = FutureProvider.family<MatchupStats, MatchupParams>;

// Управление списком матчей
final matchesNotifierProvider = StateNotifierProvider<MatchesNotifier>;
```

### Использование в UI
```dart
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(allMatchesProvider);
    
    return matchesAsync.when(
      data: (matches) => ListView(...),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

## 🧪 Тестовые данные

Текущая версия включает тестовый набор данных:
- **Liverpool vs Nottingham**: 13 матчей
  - Обе забили 6+: 12 из 13 (92.3%)
  - Разброс счётов: 5-7 до 9-8
  - Распределено по разным сезонам

## 📈 Дальнейшее развитие

### Запланированные улучшения
- [ ] Интеграция с реальным API 1xbet
- [ ] Фильтры по турнирам и датам
- [ ] Графики трендов (fl_chart)
- [ ] Уведомления о новых матчах
- [ ] Экспорт аналитики в Excel
- [ ] Сравнение разных противостояний
- [ ] Прогнозы на основе ML

### Возможности расширения
- Добавление других типов ставок
- Анализ общего числа голов
- Статистика по командам
- Интеграция с другими букмекерами

## 🐛 Отладка

### Логи
Приложение использует `logger` пакет:
```dart
_logger.i('Info message');   // Информация
_logger.w('Warning');        // Предупреждение
_logger.e('Error');          // Ошибка
```

### Анализ кода
```bash
flutter analyze  # Статический анализ
flutter test     # Запуск тестов
```

## 📄 Лицензия

MIT License - используйте свободно для личных и коммерческих проектов.

## 👨‍💻 Автор

Создано с использованием GitHub Copilot для анализа ставок на FIFA FC24 4x4.
