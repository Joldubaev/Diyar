import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Use case для обновления токена, если он истек
@injectable
class RefreshTokenIfNeededUseCase {
  final AuthRepository _repository;
  final LocalStorage _localStorage;

  RefreshTokenIfNeededUseCase(this._repository, this._localStorage);

  Future<Either<Failure, void>> call() async {
    final token = _localStorage.getString(AppConst.accessToken);

    if (token == null || !JwtDecoder.isExpired(token)) {
      return const Right(null);
    }

    return await _repository.refreshToken();
  }
}
