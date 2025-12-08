import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:diyar/features/templates/domain/repository/template_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTemplatesUseCase {
  final TemplateRepository _repository;

  GetTemplatesUseCase(this._repository);

  Future<Either<Failure, List<TemplateEntity>>> call() {
    return _repository.getAllTemplates();
  }
}
