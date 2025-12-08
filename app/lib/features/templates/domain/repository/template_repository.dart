import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';

abstract class TemplateRepository {
  Future<Either<Failure, List<TemplateEntity>>> getAllTemplates();
  Future<Either<Failure, TemplateEntity>> getTemplateById(String templateId);
  Future<Either<Failure, void>> createTemplate(TemplateEntity template);
  Future<Either<Failure, void>> updateTemplate(TemplateEntity template);
  Future<Either<Failure, void>> deleteTemplate(String templateId);
}
