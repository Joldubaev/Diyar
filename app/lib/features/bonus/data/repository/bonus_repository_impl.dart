import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/bonus.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BonusRepository)
class BonusRepositoryImpl implements BonusRepository {
  final BonusRemoteDataSource _remoteDataSource;

  BonusRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, QrGenerateEntity>> generateQr() async {
    try {
      final result = await _remoteDataSource.generateQr();
      return result.fold(
        (failure) => Left(failure),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }
}
