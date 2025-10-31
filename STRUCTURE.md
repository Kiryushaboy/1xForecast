# Структура проекта 1xForecast

## 📁 Организация кода

### Core (Ядро приложения)
```
lib/core/
├── bloc/                   # Базовые классы для состояний
│   └── base_state.dart
├── constants/              # Константы UI
│   └── ui_constants.dart
├── theme/                  # Тема приложения
│   ├── colors/            # Цветовая палитра
│   │   └── app_colors.dart
│   ├── gradients/         # Градиенты
│   │   └── app_gradients.dart
│   ├── app_theme.dart     # Основная тема
│   ├── theme_cubit.dart   # Управление темой
│   └── theme_extensions.dart  # Расширения для быстрого доступа
├── utils/                  # Утилиты
│   └── helpers.dart
└── widgets/               # Переиспользуемые виджеты
    ├── animations/        # Анимации
    │   ├── animated_gradient_card.dart
    │   ├── pulse_animation.dart
    │   ├── shimmer_loading.dart
    │   └── animations.dart (barrel export)
    ├── buttons/           # Кнопки
    │   └── buttons.dart
    ├── cards/             # Карточки
    │   ├── base_card.dart
    │   ├── glass_card.dart
    │   └── cards.dart (barrel export)
    ├── layouts/           # Лейауты
    │   └── layouts.dart
    ├── states/            # Виджеты состояний
    │   ├── state_widget.dart
    │   └── states.dart (barrel export)
    └── widgets.dart       # Главный barrel export
```

### Features (Функции приложения)

#### Matches (Матчи)
```
lib/features/matches/
├── data/
│   ├── datasources/
│   │   ├── bet_parser_service.dart    # Парсинг данных
│   │   └── match_local_datasource.dart  # Локальное хранилище
│   └── repositories/
│       └── match_repository_impl.dart  # Реализация репозитория
├── domain/
│   ├── entities/
│   │   ├── match.dart                 # Модель матча
│   │   └── matchup.dart               # Модель противостояния
│   └── repositories/
│       └── match_repository.dart      # Интерфейс репозитория
└── presentation/
    ├── bloc/
    │   └── match_bloc.dart            # Логика состояний
    ├── pages/
    │   ├── home/                      # Компоненты главной страницы
    │   │   ├── home_app_bar.dart      # AppBar
    │   │   ├── home_stats_header.dart # Заголовок со статистикой
    │   │   ├── home_matchups_list.dart  # Список противостояний
    │   │   ├── home_matchups_content.dart  # Основной контент
    │   │   └── home_load_data_fab.dart  # FAB для загрузки
    │   └── home_page.dart             # Главная страница (116 строк!)
    └── widgets/
        ├── matchup_card.dart          # Карточка противостояния
        └── stats_card.dart            # Карточка статистики
```

#### Analysis (Анализ)
```
lib/features/analysis/
├── domain/
│   ├── entities/
│   │   └── matchup_stats.dart         # Статистика противостояний
│   └── services/
│       └── matchup_analyzer.dart      # Анализатор матчей
└── presentation/
    ├── bloc/
    │   └── analysis_bloc.dart         # Логика анализа
    └── pages/
        ├── matchup_analysis/          # Компоненты страницы анализа
        │   └── (будут добавлены)
        └── matchup_analysis_page.dart # Страница анализа
```

## 🎯 Принципы организации

### 1. Модульность
- Каждый компонент в отдельном файле
- Максимум 150 строк на файл
- Чёткая ответственность каждого файла

### 2. Barrel Exports
- Удобный импорт через `animations.dart`, `cards.dart` и т.д.
- Один импорт вместо множества

### 3. Чистая архитектура
- **Domain**: Бизнес-логика (entities, repositories, services)
- **Data**: Реализация данных (datasources, repositories impl)
- **Presentation**: UI (pages, widgets, BLoC)

### 4. Компоненты страниц
- Большие страницы разбиты на компоненты
- Каждый компонент в папке `/home/` или `/matchup_analysis/`
- Главный файл страницы - координатор компонентов

## 📊 Статистика улучшений

### Было:
- `home_page.dart` - 381 строка
- `animated_widgets.dart` - 267 строк
- `app_theme.dart` - 324 строки
- Всё в одном файле

### Стало:
- `home_page.dart` - **116 строк** (-70%)
- 5 компонентов home/* - по 30-80 строк каждый
- 4 файла анимаций - по 50 строк каждый
- `app_colors.dart` - 29 строк
- `app_gradients.dart` - 58 строк
- Модульная структура

## 🚀 Как использовать

### Импорт виджетов:
```dart
import 'package:forecast_app/core/widgets/widgets.dart';
// Теперь доступны все виджеты!
```

### Импорт анимаций:
```dart
import 'package:forecast_app/core/widgets/animations/animations.dart';
```

### Импорт карточек:
```dart
import 'package:forecast_app/core/widgets/cards/cards.dart';
```

### Импорт цветов и градиентов:
```dart
import 'package:forecast_app/core/theme/colors/app_colors.dart';
import 'package:forecast_app/core/theme/gradients/app_gradients.dart';
```

## ✨ Преимущества новой структуры

1. **Легко найти код** - понятная иерархия папок
2. **Легко читать** - короткие файлы, одна задача на файл
3. **Легко тестировать** - изолированные компоненты
4. **Легко расширять** - добавляй новые файлы в нужную папку
5. **Легко поддерживать** - чёткая структура, нет "кашималаши"
