import 'package:dartz/dartz.dart';
// import 'package:diyar/core/error/failure.dart'; // Временно
// import 'package:diyar/core/usecase/usecase.dart'; // Убираем базовый UseCase
import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:diyar/features/home_content/domain/repositories/home_content_repository.dart';
import 'package:injectable/injectable.dart';

// Упрощенный UseCase без базового класса и параметров
@injectable
class GetNewsUseCase {
  final HomeContentRepository repository;

  GetNewsUseCase(this.repository);

  // Метод call остается для единообразия вызова
  Future<Either<dynamic, List<NewsEntity>>> call() async {
    return await repository.getNews();
  }
}
