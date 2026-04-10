import 'package:fpdart/fpdart.dart';
import 'package:diyar/core/error/failure.dart';
import '../entities/timer_entites.dart';

abstract interface class SettingsRepository {
  Future<Either<Failure, TimerEntites>> getTimer();
}
