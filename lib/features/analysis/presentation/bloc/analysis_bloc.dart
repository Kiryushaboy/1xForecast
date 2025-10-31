import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../matches/domain/repositories/match_repository.dart';
import '../../domain/entities/matchup_stats.dart';
import '../../domain/services/matchup_analyzer.dart';

// Events
abstract class AnalysisEvent {}

class LoadMatchupStats extends AnalysisEvent {
  final String homeTeam;
  final String awayTeam;

  LoadMatchupStats({required this.homeTeam, required this.awayTeam});
}

class LoadSeasonStats extends AnalysisEvent {
  final String homeTeam;
  final String awayTeam;

  LoadSeasonStats({required this.homeTeam, required this.awayTeam});
}

class LoadLastNStats extends AnalysisEvent {
  final String homeTeam;
  final String awayTeam;
  final int count;

  LoadLastNStats({
    required this.homeTeam,
    required this.awayTeam,
    required this.count,
  });
}

// States
abstract class AnalysisState {}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class MatchupStatsLoaded extends AnalysisState {
  final MatchupStats stats;
  MatchupStatsLoaded(this.stats);
}

class SeasonStatsLoaded extends AnalysisState {
  final List<SeasonStats> stats;
  SeasonStatsLoaded(this.stats);
}

class AnalysisError extends AnalysisState {
  final String message;
  AnalysisError(this.message);
}

// Bloc
class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final MatchRepository repository;
  late final MatchupAnalyzer analyzer;

  AnalysisBloc(this.repository) : super(AnalysisInitial()) {
    analyzer = MatchupAnalyzer(repository);

    on<LoadMatchupStats>(_onLoadMatchupStats);
    on<LoadSeasonStats>(_onLoadSeasonStats);
    on<LoadLastNStats>(_onLoadLastNStats);
  }

  Future<void> _onLoadMatchupStats(
    LoadMatchupStats event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      final stats = await analyzer.analyzeMatchup(
        homeTeam: event.homeTeam,
        awayTeam: event.awayTeam,
      );
      emit(MatchupStatsLoaded(stats));
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }

  Future<void> _onLoadSeasonStats(
    LoadSeasonStats event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      final stats = await analyzer.getSeasonStats(
        homeTeam: event.homeTeam,
        awayTeam: event.awayTeam,
      );
      emit(SeasonStatsLoaded(stats));
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }

  Future<void> _onLoadLastNStats(
    LoadLastNStats event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      final stats = await analyzer.getLastNStats(
        homeTeam: event.homeTeam,
        awayTeam: event.awayTeam,
        count: event.count,
      );
      emit(MatchupStatsLoaded(stats));
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }
}
