import 'package:fpdart/fpdart.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/web_payment/data/datasource/open_banking_remote_datasource.dart';
import 'package:diyar/features/web_payment/domain/repository/i_open_banking_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IOpenBankingRepository)
class OpenBankingRepositoryImpl implements IOpenBankingRepository {
  final OpenBankingRemoteDatasource _datasource;

  OpenBankingRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, String>> createPayLink({
    required int amount,
    required String orderNumber,
  }) => _datasource.createPayLink(amount: amount, orderNumber: orderNumber);
}
