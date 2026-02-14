import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Use case для проверки номера телефона
@injectable
class CheckPhoneNumberUseCase {
  final AuthRepository _repository;

  CheckPhoneNumberUseCase(this._repository);

  Future<Either<Failure, bool>> call(String phone) async {
    return _repository.checkPhoneNumber(phone);
  }
}
