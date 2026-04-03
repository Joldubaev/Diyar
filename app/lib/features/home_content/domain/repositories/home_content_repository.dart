import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:fpdart/fpdart.dart' show Either;

abstract class HomeContentRepository {
  Future<Either<Failure, List<NewsEntity>>> getNews();
  Future<Either<Failure, List<SaleEntity>>> getSales();
}
