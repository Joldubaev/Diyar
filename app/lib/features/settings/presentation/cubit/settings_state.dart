part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class TimerLoading extends SettingsState {}

final class TimerError extends SettingsState {
  final String message;
  const TimerError(this.message);
}

final class TimerLoaded extends SettingsState {
  final TimerEntites timer;

  const TimerLoaded(this.timer);
}
