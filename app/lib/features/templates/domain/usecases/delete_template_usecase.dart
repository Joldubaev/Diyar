import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/domain/repository/template_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteTemplateUseCase {
  final TemplateRepository _repository;

  DeleteTemplateUseCase(this._repository);

  Future<Either<Failure, void>> call(String templateId) {
    return _repository.deleteTemplate(templateId);
  }
}
