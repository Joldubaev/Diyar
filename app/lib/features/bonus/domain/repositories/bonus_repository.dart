import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/domain/entities/entities.dart';

abstract class BonusRepository {
  Future<Either<Failure, QrGenerateEntity>> generateQr();
}
