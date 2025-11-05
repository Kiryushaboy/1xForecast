import '../../domain/entities/match.dart';
import 'test_data_generator.dart';

/// Временное хранилище в памяти для отладки в браузере
/// Использует простой List вместо Hive
class MatchMemoryDataSource {
  // Хранилище в памяти
  final List<Match> _matches = [];
  bool _testDataLoaded = false;

  Future<List<Match>> getMatches() async {
    // Автоматически загружаем тестовые данные при первом запросе
    if (!_testDataLoaded && _matches.isEmpty) {
      _matches.addAll(TestDataGenerator.generateTestMatches());
      _testDataLoaded = true;
      print('🎯 Загружено ${_matches.length} тестовых матчей');
      print(TestDataGenerator.getTestDataSummary());
    }

    // Возвращаем копию списка, чтобы избежать модификации оригинала
    return List<Match>.from(_matches);
  }

  Future<void> saveMatches(List<Match> matches) async {
    _matches.clear();
    _matches.addAll(matches);
  }

  Future<void> addMatch(Match match) async {
    _matches.add(match);
  }

  Future<void> clearMatches() async {
    _matches.clear();
  }

  // Метод для совместимости с интерфейсом
  Future<void> close() async {
    // Ничего не делаем для in-memory storage
  }
}
