import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:diyar/features/templates/domain/repository/template_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTemplateByIdUseCase {
  final TemplateRepository _repository;

  GetTemplateByIdUseCase(this._repository);

  Future<Either<Failure, TemplateEntity>> call(String templateId) {
    return _repository.getTemplateById(templateId);
  }
}
