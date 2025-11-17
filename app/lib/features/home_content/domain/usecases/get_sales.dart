import 'package:dartz/dartz.dart';
// import 'package:diyar/core/error/failure.dart'; // Временно
import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:diyar/features/home_content/domain/repositories/home_content_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSalesUseCase {
  final HomeContentRepository repository;

  GetSalesUseCase(this.repository);

  Future<Either<dynamic, List<SaleEntity>>> call() async {
    return await repository.getSales();
  }
}
