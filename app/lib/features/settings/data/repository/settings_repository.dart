import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import '../../domain/domain.dart';
import '../../domain/entities/timer_entites.dart';
import '../datasource/remote_settings_datasource.dart';

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
