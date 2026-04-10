import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:diyar/features/home_content/domain/repositories/home_content_repository.dart';
import 'package:fpdart/fpdart.dart' show Either;
import 'package:injectable/injectable.dart';

@injectable
class GetSalesUseCase {
  final HomeContentRepository repository;

  GetSalesUseCase(this.repository);

  Future<Either<Failure, List<SaleEntity>>> call() {
    return repository.getSales();
  }
}
