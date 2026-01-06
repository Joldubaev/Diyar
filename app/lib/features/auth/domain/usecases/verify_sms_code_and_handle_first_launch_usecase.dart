import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

/// Use case для верификации SMS кода и обработки первого запуска
@injectable
class VerifySmsCodeAndHandleFirstLaunchUseCase {
  final AuthRepository _repository;
  final SecureStorageService _secureStorage;

  VerifySmsCodeAndHandleFirstLaunchUseCase(
    this._repository,
    this._secureStorage,
  );

  Future<Either<Failure, void>> call(String phone, String code) async {
    final verifyResult = await _repository.verifyCodeForLogin(phone, code);

    return verifyResult.fold(
      (failure) => Left(failure),
      (_) async {
        // Обработка первого запуска
        final isFirstLaunch = await _secureStorage.isFirstLaunch();
        if (isFirstLaunch) {
          await _secureStorage.setFirstLaunchCompleted();
        }
        return const Right(null);
      },
    );
  }
}
