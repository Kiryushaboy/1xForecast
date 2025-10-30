import '../entities/matchup_stats.dart';
import '../../../matches/domain/entities/match.dart';
import '../../../matches/domain/repositories/match_repository.dart';
import '../../../../core/utils/helpers.dart';

class MatchupAnalyzer {
  final MatchRepository _matchRepository;

  MatchupAnalyzer(this._matchRepository);

  Future<MatchupStats> analyzeMatchup({
    required String homeTeam,
    required String awayTeam,
  }) async {
    final matches = await _matchRepository.getMatchesByMatchup(
      homeTeam: homeTeam,
      awayTeam: awayTeam,
    );

    matches.sort((a, b) => b.date.compareTo(a.date));

    return MatchupStats.fromMatches(
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      matches: matches,
    );
  }

  Future<List<Match>> getLastNMatches({
    required String homeTeam,
    required String awayTeam,
    required int count,
  }) async {
    final matches = await _matchRepository.getMatchesByMatchup(
      homeTeam: homeTeam,
      awayTeam: awayTeam,
    );

    matches.sort((a, b) => b.date.compareTo(a.date));

    return matches.take(count).toList();
  }

  Future<List<SeasonStats>> getSeasonStats({
    required String homeTeam,
    required String awayTeam,
  }) async {
    final matches = await _matchRepository.getMatchesByMatchup(
      homeTeam: homeTeam,
      awayTeam: awayTeam,
    );

    final Map<int, List<Match>> seasonMatches = {};

    for (var match in matches) {
      final season = DateUtils.calculateSeasonNumber(match.date);
      seasonMatches.putIfAbsent(season, () => []).add(match);
    }

    final stats = <SeasonStats>[];
    for (var entry in seasonMatches.entries) {
      final seasonMatchList = entry.value;
      final bothScored6Plus =
          seasonMatchList.where((m) => m.bothTeamsScored(6)).length;

      stats.add(SeasonStats(
        season: entry.key,
        totalMatches: seasonMatchList.length,
        bothScored6Plus: bothScored6Plus,
        percentage: seasonMatchList.isEmpty
            ? 0.0
            : (bothScored6Plus / seasonMatchList.length) * 100,
      ));
    }

    stats.sort((a, b) => a.season.compareTo(b.season));
    return stats;
  }

  Future<MatchupStats> getLastNStats({
    required String homeTeam,
    required String awayTeam,
    required int count,
  }) async {
    final lastMatches = await getLastNMatches(
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      count: count,
    );

    return MatchupStats.fromMatches(
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      matches: lastMatches,
    );
  }
}
