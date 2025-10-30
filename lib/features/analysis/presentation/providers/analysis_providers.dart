import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../matches/presentation/providers/match_providers.dart';
import '../../domain/entities/matchup_stats.dart';
import '../../domain/services/matchup_analyzer.dart';

final matchupAnalyzerProvider = Provider<MatchupAnalyzer>((ref) {
  final repository = ref.watch(matchRepositoryProvider);
  return MatchupAnalyzer(repository);
});

final matchupStatsProvider =
    FutureProvider.family<MatchupStats, MatchupParams>((ref, params) async {
  final analyzer = ref.watch(matchupAnalyzerProvider);
  return await analyzer.analyzeMatchup(
    homeTeam: params.homeTeam,
    awayTeam: params.awayTeam,
  );
});

final seasonStatsProvider =
    FutureProvider.family<List<SeasonStats>, MatchupParams>(
        (ref, params) async {
  final analyzer = ref.watch(matchupAnalyzerProvider);
  return await analyzer.getSeasonStats(
    homeTeam: params.homeTeam,
    awayTeam: params.awayTeam,
  );
});

class LastNStatsParams {
  final String homeTeam;
  final String awayTeam;
  final int count;

  const LastNStatsParams({
    required this.homeTeam,
    required this.awayTeam,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LastNStatsParams &&
          runtimeType == other.runtimeType &&
          homeTeam == other.homeTeam &&
          awayTeam == other.awayTeam &&
          count == other.count;

  @override
  int get hashCode => homeTeam.hashCode ^ awayTeam.hashCode ^ count.hashCode;
}

final lastNStatsProvider =
    FutureProvider.family<MatchupStats, LastNStatsParams>((ref, params) async {
  final analyzer = ref.watch(matchupAnalyzerProvider);
  return await analyzer.getLastNStats(
    homeTeam: params.homeTeam,
    awayTeam: params.awayTeam,
    count: params.count,
  );
});
