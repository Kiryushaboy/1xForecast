import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/match_local_datasource.dart';
import '../../data/datasources/bet_parser_service.dart';
import '../../data/repositories/match_repository_impl.dart';
import '../../domain/repositories/match_repository.dart';
import '../../domain/entities/match.dart';

final betParserServiceProvider = Provider<BetParserService>((ref) {
  return BetParserService();
});

final matchLocalDataSourceProvider = Provider<MatchLocalDataSource>((ref) {
  return MatchLocalDataSource();
});

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  final dataSource = ref.watch(matchLocalDataSourceProvider);
  return MatchRepositoryImpl(dataSource);
});

final allMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final repository = ref.watch(matchRepositoryProvider);
  return await repository.getAllMatches();
});

final matchesByTeamProvider =
    FutureProvider.family<List<Match>, String>((ref, teamName) async {
  final repository = ref.watch(matchRepositoryProvider);
  return await repository.getMatchesByTeam(teamName);
});

class MatchupParams {
  final String homeTeam;
  final String awayTeam;

  const MatchupParams({required this.homeTeam, required this.awayTeam});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchupParams &&
          runtimeType == other.runtimeType &&
          homeTeam == other.homeTeam &&
          awayTeam == other.awayTeam;

  @override
  int get hashCode => homeTeam.hashCode ^ awayTeam.hashCode;
}

final matchesByMatchupProvider =
    FutureProvider.family<List<Match>, MatchupParams>((ref, params) async {
  final repository = ref.watch(matchRepositoryProvider);
  return await repository.getMatchesByMatchup(
    homeTeam: params.homeTeam,
    awayTeam: params.awayTeam,
  );
});

class MatchesNotifier extends StateNotifier<AsyncValue<List<Match>>> {
  final MatchRepository repository;

  MatchesNotifier(this.repository) : super(const AsyncValue.loading()) {
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    state = const AsyncValue.loading();
    try {
      final matches = await repository.getAllMatches();
      state = AsyncValue.data(matches);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addMatch(Match match) async {
    await repository.addMatch(match);
    await _loadMatches();
  }

  Future<void> saveMatches(List<Match> matches) async {
    await repository.saveMatches(matches);
    await _loadMatches();
  }

  Future<void> clearAllMatches() async {
    await repository.clearAllMatches();
    await _loadMatches();
  }

  Future<void> filterMatches({
    String? tournament,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      final filtered = await repository.filterMatches(
        tournament: tournament,
        startDate: startDate,
        endDate: endDate,
      );
      state = AsyncValue.data(filtered);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadMatches();
  }
}

final matchesNotifierProvider =
    StateNotifierProvider<MatchesNotifier, AsyncValue<List<Match>>>((ref) {
  final repository = ref.watch(matchRepositoryProvider);
  return MatchesNotifier(repository);
});
