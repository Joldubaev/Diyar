import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:diyar/features/templates/domain/repository/template_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTemplateUseCase {
  final TemplateRepository _repository;

  UpdateTemplateUseCase(this._repository);

  Future<Either<Failure, void>> call(TemplateEntity template) {
    return _repository.updateTemplate(template);
  }
}
