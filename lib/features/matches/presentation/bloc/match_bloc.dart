import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';

// Events
abstract class MatchEvent {}

class LoadMatches extends MatchEvent {}

class AddMatch extends MatchEvent {
  final Match match;
  AddMatch(this.match);
}

class SaveMatches extends MatchEvent {
  final List<Match> matches;
  SaveMatches(this.matches);
}

class ClearMatches extends MatchEvent {}

class FilterMatches extends MatchEvent {
  final String? tournament;
  final DateTime? startDate;
  final DateTime? endDate;

  FilterMatches({this.tournament, this.startDate, this.endDate});
}

// States
abstract class MatchState {}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchLoaded extends MatchState {
  final List<Match> matches;
  MatchLoaded(this.matches);
}

class MatchError extends MatchState {
  final String message;
  MatchError(this.message);
}

// Bloc
class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchRepository _repository;

  MatchBloc(MatchRepository repository)
      : _repository = repository,
        super(MatchInitial()) {
    on<LoadMatches>(_onLoadMatches);
    on<AddMatch>(_onAddMatch);
    on<SaveMatches>(_onSaveMatches);
    on<ClearMatches>(_onClearMatches);
    on<FilterMatches>(_onFilterMatches);
  }

  Future<void> _onLoadMatches(
    LoadMatches event,
    Emitter<MatchState> emit,
  ) async {
    emit(MatchLoading());
    try {
      final matches = await _repository.getAllMatches();
      emit(MatchLoaded(matches));
    } catch (e) {
      emit(MatchError(e.toString()));
    }
  }

  Future<void> _onAddMatch(
    AddMatch event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await _repository.addMatch(event.match);
      add(LoadMatches());
    } catch (e) {
      emit(MatchError(e.toString()));
    }
  }

  Future<void> _onSaveMatches(
    SaveMatches event,
    Emitter<MatchState> emit,
  ) async {
    emit(MatchLoading());
    try {
      await _repository.saveMatches(event.matches);
      emit(MatchLoaded(event.matches));
    } catch (e) {
      emit(MatchError(e.toString()));
    }
  }

  Future<void> _onClearMatches(
    ClearMatches event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await _repository.clearAllMatches();
      emit(MatchLoaded([]));
    } catch (e) {
      emit(MatchError(e.toString()));
    }
  }

  Future<void> _onFilterMatches(
    FilterMatches event,
    Emitter<MatchState> emit,
  ) async {
    emit(MatchLoading());
    try {
      final matches = await _repository.filterMatches(
        tournament: event.tournament,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(MatchLoaded(matches));
    } catch (e) {
      emit(MatchError(e.toString()));
    }
  }
}
