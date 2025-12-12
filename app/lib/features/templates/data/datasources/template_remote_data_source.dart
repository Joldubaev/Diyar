import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/data/model/template_model.dart';

abstract class TemplateRemoteDataSource {
  Future<Either<Failure, List<TemplateModel>>> getAllTemplates();
  Future<Either<Failure, TemplateModel>> getTemplateById(String templateId);
  Future<Either<Failure, void>> createTemplate(TemplateModel template);
  Future<Either<Failure, void>> updateTemplate(TemplateModel template);
  Future<Either<Failure, void>> deleteTemplate(String templateId);
}
