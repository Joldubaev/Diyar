import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:diyar/features/home_content/domain/repositories/home_content_repository.dart';
import 'package:fpdart/fpdart.dart' show Either;
import 'package:injectable/injectable.dart';

@injectable
class GetNewsUseCase {
  final HomeContentRepository repository;

  GetNewsUseCase(this.repository);

  Future<Either<Failure, List<NewsEntity>>> call() {
    return repository.getNews();
  }
}
