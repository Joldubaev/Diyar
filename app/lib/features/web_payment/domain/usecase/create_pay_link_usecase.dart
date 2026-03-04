import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/web_payment/domain/repository/i_open_banking_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreatePayLinkUsecase {
  final IOpenBankingRepository _repository;

  CreatePayLinkUsecase(this._repository);

  /// Создаёт платёжную ссылку.
  /// POST /api/v1/openbanking/create-pay-link
  /// Body: { "amount": number, "orderNumber": string }
  Future<Either<Failure, String>> call({
    required int amount,
    required String orderNumber,
  }) =>
      _repository.createPayLink(amount: amount, orderNumber: orderNumber);
}
