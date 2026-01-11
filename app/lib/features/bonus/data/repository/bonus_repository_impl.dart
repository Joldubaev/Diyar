import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/bonus.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BonusRepository)
class BonusRepositoryImpl with RepositoryErrorHandler implements BonusRepository {
  final BonusRemoteDataSource _remoteDataSource;

  BonusRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, QrGenerateEntity>> generateQr() {
    return makeRequest(() async {
      final model = await _remoteDataSource.generateQr();
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, BonusTransactionResponseEntity>> getBonusTransactions({
    int page = 1,
    int pageSize = 50,
    String? userId,
    String? transactionType,
    String? dateFrom,
    String? dateTo,
  }) {
    return makeRequest(() async {
      final model = await _remoteDataSource.getBonusTransactions(
        page: page,
        pageSize: pageSize,
        userId: userId,
        transactionType: transactionType,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      return model.toEntity();
    });
  }
}
