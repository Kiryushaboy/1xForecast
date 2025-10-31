/// Базовый класс для всех состояний в приложении
abstract class BaseState {}

/// Начальное состояние
class InitialState extends BaseState {}

/// Состояние загрузки
class LoadingState extends BaseState {}

/// Успешное состояние с данными
class LoadedState<T> extends BaseState {
  final T data;
  LoadedState(this.data);
}

/// Состояние ошибки
class ErrorState extends BaseState {
  final String message;
  ErrorState(this.message);
}
