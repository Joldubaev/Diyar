import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';

/// Отдельный репозиторий для смены статуса оплаты заказа курьера.
abstract class CurierPaymentRepository {
  Future<Either<Failure, Unit>> setOrderPaymentStatus({
    required int orderNumber,
    required String paymentStatus,
  });
}

