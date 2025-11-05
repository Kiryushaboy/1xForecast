import '../../domain/entities/match.dart';

/// Хранилище в памяти для матчей
/// Данные загружаются из кеша через MatchBloc
class MatchMemoryDataSource {
  // Хранилище в памяти
  final List<Match> _matches = [];

  Future<List<Match>> getMatches() async {
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
