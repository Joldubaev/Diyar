import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Use case для обновления токена, если он истек
@injectable
class RefreshTokenIfNeededUseCase {
  final AuthRepository _repository;
  final SecureStorageService _secureStorage;

  RefreshTokenIfNeededUseCase(this._repository, this._secureStorage);

  Future<Either<Failure, void>> call() async {
    final token = await _secureStorage.getAccessToken();

    if (token == null || !JwtDecoder.isExpired(token)) {
      return const Right(null);
    }

    return await _repository.refreshToken();
  }
}
