import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/match_local_datasource.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchLocalDataSource _localDataSource;

  MatchRepositoryImpl(this._localDataSource);

  @override
  Future<List<Match>> getAllMatches() async {
    return await _localDataSource.getMatches();
  }

  @override
  Future<List<Match>> getMatchesByTeam(String teamName) async {
    final matches = await _localDataSource.getMatches();
    return matches
        .where((match) =>
            match.homeTeam.toLowerCase() == teamName.toLowerCase() ||
            match.awayTeam.toLowerCase() == teamName.toLowerCase())
        .toList();
  }

  @override
  Future<List<Match>> getMatchesByMatchup({
    required String homeTeam,
    required String awayTeam,
  }) async {
    final matches = await _localDataSource.getMatches();
    return matches
        .where((match) =>
            match.homeTeam.toLowerCase() == homeTeam.toLowerCase() &&
            match.awayTeam.toLowerCase() == awayTeam.toLowerCase())
        .toList();
  }

  @override
  Future<void> saveMatches(List<Match> matches) async {
    await _localDataSource.saveMatches(matches);
  }

  @override
  Future<void> addMatch(Match match) async {
    await _localDataSource.addMatch(match);
  }

  @override
  Future<void> clearAllMatches() async {
    await _localDataSource.clearMatches();
  }

  @override
  Future<List<Match>> filterMatches({
    String? tournament,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var matches = await _localDataSource.getMatches();

    if (tournament != null) {
      matches = matches
          .where((m) => m.tournament.toLowerCase() == tournament.toLowerCase())
          .toList();
    }

    if (startDate != null) {
      matches = matches
          .where((m) =>
              m.date.isAfter(startDate) || m.date.isAtSameMomentAs(startDate))
          .toList();
    }

    if (endDate != null) {
      matches = matches
          .where((m) =>
              m.date.isBefore(endDate) || m.date.isAtSameMomentAs(endDate))
          .toList();
    }

    return matches;
  }
}
