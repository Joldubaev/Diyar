import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/domain/entities/entities.dart';

/// Repository для работы с бонусной системой
abstract class BonusRepository {
  /// Генерирует QR код для бонусной системы
  /// Возвращает QrGenerateEntity с URL для QR кода
  Future<Either<Failure, QrGenerateEntity>> generateQr();
}
