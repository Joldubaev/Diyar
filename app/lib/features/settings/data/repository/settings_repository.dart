import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../domain/entities/timer_entites.dart';
import '../datasource/remote_settings_datasource.dart';
import '../models/timer_model.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final RemoteSettingsDataSource _remoteDataSource;

  SettingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, TimerEntites>> getTimer() async {
    final result = await _remoteDataSource.getTimer();
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }
}
