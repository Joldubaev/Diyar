import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:diyar/features/templates/domain/repository/template_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateTemplateUseCase {
  final TemplateRepository _repository;

  CreateTemplateUseCase(this._repository);

  Future<Either<Failure, void>> call(TemplateEntity template) {
    return _repository.createTemplate(template);
  }
}
