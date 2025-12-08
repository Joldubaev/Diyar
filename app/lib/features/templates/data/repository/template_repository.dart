import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/data/datasources/template_remote_data_source.dart';
import 'package:diyar/features/templates/data/model/template_model.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:diyar/features/templates/domain/repository/template_repository.dart' as domain;
import 'package:injectable/injectable.dart';

@LazySingleton(as: domain.TemplateRepository)
class TemplateRepositoryImpl implements domain.TemplateRepository {
  final TemplateRemoteDataSource _remoteDataSource;

  TemplateRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<TemplateEntity>>> getAllTemplates() async {
    final result = await _remoteDataSource.getAllTemplates();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, TemplateEntity>> getTemplateById(String templateId) async {
    final result = await _remoteDataSource.getTemplateById(templateId);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, void>> createTemplate(TemplateEntity template) {
    final model = TemplateModel.fromEntity(template);
    return _remoteDataSource.createTemplate(model);
  }

  @override
  Future<Either<Failure, void>> updateTemplate(TemplateEntity template) {
    final model = TemplateModel.fromEntity(template);
    return _remoteDataSource.updateTemplate(model);
  }

  @override
  Future<Either<Failure, void>> deleteTemplate(String templateId) {
    return _remoteDataSource.deleteTemplate(templateId);
  }
}
