import 'package:dartz/dartz.dart'; // Для Either
import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';

abstract class HomeContentRepository {
  // Указываем dynamic вместо Failure временно
  Future<Either<dynamic, List<NewsEntity>>> getNews();
  Future<Either<dynamic, List<SaleEntity>>> getSales();
}
