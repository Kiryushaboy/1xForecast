import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import '../../../../core/services/match_cache_service.dart';
import '../../../../core/services/scheduled_update_service.dart';
import '../../../../core/services/betting_parser_service.dart';

// Events
abstract class MatchEvent {}

class LoadMatches extends MatchEvent {}

/// Загружает матчи из кеша (при старте приложения)
class FetchCachedMatches extends MatchEvent {}

/// Обновляет матчи с 1xbet и сохраняет в кеш (pull-to-refresh)
class RefreshMatches extends MatchEvent {}

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
  // ignore: unused_field
  final MatchCacheService _cacheService;
  // ignore: unused_field
  final ScheduledUpdateService _updateService;

  MatchBloc({
    required MatchRepository repository,
    required MatchCacheService cacheService,
    required ScheduledUpdateService updateService,
  })  : _repository = repository,
        _cacheService = cacheService,
        _updateService = updateService,
        super(MatchInitial()) {
    on<LoadMatches>(_onLoadMatches);
    on<FetchCachedMatches>(_onFetchCachedMatches);
    on<RefreshMatches>(_onRefreshMatches);
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

  Future<void> _onFetchCachedMatches(
    FetchCachedMatches event,
    Emitter<MatchState> emit,
  ) async {
    emit(MatchLoading());
    try {
      print('🚀 MatchBloc: Загрузка данных при старте...');

      // TODO: Закомментировано кеширование - парсим напрямую
      // final cachedMatches = await _cacheService.getCachedMatches();

      // Парсим напрямую с сайта
      print('🔄 MatchBloc: Парсим с 1xbet при старте приложения...');
      final parserService = BettingParserService();
      final matches = await parserService.parseMatches();

      print('📦 MatchBloc: Получено ${matches.length} матчей');

      if (matches.isNotEmpty) {
        // Сохраняем в репозиторий для текущей сессии
        await _repository.saveMatches(matches);
        print('✅ MatchBloc: Данные загружены при старте');
        emit(MatchLoaded(matches));
      } else {
        print('⚠️ MatchBloc: Не удалось загрузить матчи при старте');
        // Если парсинг не удался, показываем пустой список
        emit(MatchLoaded([]));
      }
    } catch (e, stackTrace) {
      print('❌ MatchBloc: Ошибка при загрузке - $e');
      print('Stack trace: $stackTrace');
      emit(MatchError(e.toString()));
    }
  }

  Future<void> _onRefreshMatches(
    RefreshMatches event,
    Emitter<MatchState> emit,
  ) async {
    // Не показываем MatchLoading, чтобы не скрывать текущие матчи
    // RefreshIndicator покажет свой индикатор
    try {
      print('🔄 MatchBloc: Парсим данные напрямую с 1xbet...');

      // Парсим напрямую с сайта (БЕЗ кеширования)
      final parserService = BettingParserService();
      final matches = await parserService.parseMatches();

      print('📦 MatchBloc: Получено ${matches.length} матчей от парсера');

      if (matches.isNotEmpty) {
        // Сохраняем в репозиторий (memory datasource)
        print('💾 MatchBloc: Сохраняем в репозиторий...');
        await _repository.saveMatches(matches);

        // TODO: Закомментировано кеширование
        // await _cacheService.cacheMatches(matches);

        print(
            '✅ MatchBloc: Данные сохранены, emit MatchLoaded с ${matches.length} матчами');
        emit(MatchLoaded(matches));
      } else {
        print('⚠️ MatchBloc: Парсер вернул 0 матчей');
        // Если парсинг не удался, оставляем текущие данные
        final currentState = state;
        if (currentState is MatchLoaded) {
          print(
              'ℹ️ MatchBloc: Оставляем текущие ${currentState.matches.length} матчей');
          emit(MatchLoaded(currentState.matches));
        } else {
          print('❌ MatchBloc: Нет текущих данных, emit MatchError');
          emit(MatchError('Не удалось обновить данные'));
        }
      }
    } catch (e, stackTrace) {
      print('❌ MatchBloc: Ошибка при обновлении - $e');
      print('Stack trace: $stackTrace');
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
