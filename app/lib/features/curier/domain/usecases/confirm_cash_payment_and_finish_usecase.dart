import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/curier/domain/domain.dart';
import 'package:injectable/injectable.dart';

/// UseCase: курьер подтверждает оплату НАЛИЧНЫМИ и завершает заказ.
@injectable
class ConfirmCashPaymentAndFinishUseCase {
  ConfirmCashPaymentAndFinishUseCase(
    this._paymentRepository,
    this._curierRepository,
  );

  final CurierPaymentRepository _paymentRepository;
  final CurierRepository _curierRepository;

  Future<Either<Failure, Unit>> call(CurierEntity order) async {
    final orderNumber = order.orderNumber ?? 0;
    if (orderNumber == 0) {
      // Простая Failure-обёртка, без создания инстанса абстрактного класса.
      return Left(_LocalFailure('Некорректный номер заказа'));
    }

    // 1) Отмечаем оплату Successful
    final paymentResult = await _paymentRepository.setOrderPaymentStatus(
      orderNumber: orderNumber,
      paymentStatus: 'Successful',
    );
    if (paymentResult.isLeft()) {
      return paymentResult;
    }

    // 2) Завершаем заказ
    final finishResult = await _curierRepository.getFinishOrder(orderNumber);
    return finishResult;
  }
}

/// Локальная реализация Failure для usecase (чтобы не инстанцировать абстрактный класс).
class _LocalFailure extends Failure {
  const _LocalFailure(super.message);
}

