import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/timer_entites.dart';
import '../../domain/repositories/settings_repositories.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;
  SettingsCubit(this.repository) : super(SettingsInitial());

  Future<void> getTimer() async {
    emit(TimerLoading());
    final result = await repository.getTimer();
    result.fold(
      (failure) => emit(TimerError(failure.message)),
      (timer) => emit(TimerLoaded(timer)),
    );
  }
}
