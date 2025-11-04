# Временное хранилище для веб-отладки

## Текущее состояние
Проект временно использует **in-memory storage** вместо Hive для возможности отладки в браузере.

### Что изменено:
1. Создан `match_memory_datasource.dart` - хранилище данных в памяти
2. В `main.dart` закомментирована инициализация Hive
3. В `match_repository_impl.dart` используется `MatchMemoryDataSource` вместо `MatchLocalDataSource`

### Ограничения in-memory storage:
⚠️ **ВАЖНО**: Все данные теряются при перезагрузке приложения!
- Данные хранятся только в оперативной памяти
- При обновлении страницы браузера все данные удаляются
- Подходит только для временной отладки

## Как вернуть Hive обратно

### Шаг 1: main.dart
Раскомментировать:
```dart
import 'package:hive_flutter/hive_flutter.dart';
import 'features/matches/data/datasources/match_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}
```

Изменить инициализацию:
```dart
final dataSource = MatchLocalDataSource();
```

### Шаг 2: match_repository_impl.dart
Раскомментировать:
```dart
import '../datasources/match_local_datasource.dart';
```

Изменить поле:
```dart
final MatchLocalDataSource _localDataSource;
```

### Шаг 3: Удалить временный файл
Можно удалить `match_memory_datasource.dart`, когда он больше не нужен.

## Быстрое переключение
Для удобства можно использовать условную компиляцию или переменную окружения для автоматического выбора storage при запуске.
