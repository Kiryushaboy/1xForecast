import '../entities/match.dart';

abstract class MatchRepository {
  Future<List<Match>> getAllMatches();

  Future<List<Match>> getMatchesByTeam(String teamName);

  Future<List<Match>> getMatchesByMatchup({
    required String homeTeam,
    required String awayTeam,
  });

  Future<void> saveMatches(List<Match> matches);

  Future<void> addMatch(Match match);

  Future<void> clearAllMatches();

  Future<List<Match>> filterMatches({
    String? tournament,
    DateTime? startDate,
    DateTime? endDate,
  });
}
