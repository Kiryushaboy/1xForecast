# 1xForecast - FIFA FC24 4x4 Match Analysis

🎯 Приложение для анализа статистики матчей FIFA FC24 4x4 с прогнозированием вероятности "обе команды забили 6+".

## 🚀 Быстрый старт

```bash
# Установка зависимостей
flutter pub get

# Запуск на веб
flutter run -d chrome

# Запуск на устройстве
flutter run
```

## 📊 Возможности

- ✅ Анализ противостояний команд
- ✅ Расчёт вероятности "обе забили 6+"
- ✅ Статистика по сезонам
- ✅ История всех матчей
- ✅ Цветовая индикация (🟢 ≥70%, 🟠 50-70%, 🔴 <50%)
- ✅ Локальное хранилище данных

## 🏗️ Архитектура

Проект построен на **Clean Architecture** с современным стеком:

- **State Management**: Flutter BLoC
- **Навигация**: go_router
- **Хранилище**: Hive
- **HTTP Client**: Dio (готов для API)
- **Утилиты**: Logger, Intl

### Структура проекта

```
lib/
├── core/              # Общие компоненты
│   ├── constants/     # Константы (пороги, ключи)
│   ├── utils/         # Утилиты (Color, Date)
│   └── router/        # Навигация
├── features/          # Фичи
│   ├── matches/       # Управление матчами
│   │   ├── data/      # Datasources, Repositories
│   │   ├── domain/    # Entities, Interfaces
│   │   └── presentation/  # UI, BLoCs
│   └── analysis/      # Анализ противостояний
│       ├── domain/    # Stats, Services
│       └── presentation/  # UI, BLoCs
└── main.dart          # Точка входа
```

## 📖 Документация

Подробная документация архитектуры: [ARCHITECTURE.md](ARCHITECTURE.md)

## 🧪 Текущие данные

Приложение содержит тестовые данные:
- Liverpool vs Nottingham: 13 матчей (92.3% успеха)
- Разные противостояния для демонстрации

## 🔧 Настройка API

Для интеграции с 1xbet API обновите:
`lib/features/matches/data/datasources/bet_parser_service.dart`

## 📝 Лицензия

MIT License

Минимальное Flutter приложение со счетчиком.

## Запуск

1. Убедитесь, что Flutter установлен:
```bash
flutter --version
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Запустите приложение:
```bash
flutter run
```

## Структура проекта

- `lib/main.dart` - основной файл приложения
- `pubspec.yaml` - конфигурация проекта и зависимости
- `analysis_options.yaml` - настройки линтера
