import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/domain/entities/entities.dart';
import 'package:diyar/features/bonus/domain/repositories/bonus_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case для генерации QR кода бонусной системы
@injectable
class GenerateQrUseCase {
  final BonusRepository _repository;

  GenerateQrUseCase(this._repository);

  Future<Either<Failure, QrGenerateEntity>> call() {
    return _repository.generateQr();
  }
}
