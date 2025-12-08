import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/data/model/template_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rest_client/rest_client.dart' as rest_client;

import 'template_remote_data_source.dart';

@LazySingleton(as: TemplateRemoteDataSource)
class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  final rest_client.RestClient _restClient;

  TemplateRemoteDataSourceImpl(@Named('authRestClient') this._restClient);

  @override
  Future<Either<Failure, List<TemplateModel>>> getAllTemplates() async {
    try {
      final response = await _restClient.get<dynamic>(
        ApiConst.getAllTemplates,
      );

      if (response is Map) {
        // Проверяем код ответа, если есть
        if (response.containsKey('code')) {
          final code = response['code'];
          if (code != 200 && code != 0 && code != '200' && code != '0') {
            // Это ошибка, извлекаем сообщение
            final message = response['message'];
            if (message is String) {
              return Left(ServerFailure(message));
            }
            return Left(ServerFailure('Ошибка при получении шаблонов'));
          }
        }

        // Если есть поле message, проверяем его тип
        if (response.containsKey('message')) {
          final data = response['message'];
          if (data is List) {
            final templates = data.map((json) => TemplateModel.fromJson(json as Map<String, dynamic>)).toList();
            return Right(templates);
          } else if (data is String) {
            // message - это строка ошибки
            return Left(ServerFailure(data));
          }
        }

        // Если есть поле data
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is List) {
            final templates = data.map((json) => TemplateModel.fromJson(json as Map<String, dynamic>)).toList();
            return Right(templates);
          }
        }
      } else if (response is List) {
        final templates = response.map((json) => TemplateModel.fromJson(json as Map<String, dynamic>)).toList();
        return Right(templates);
      }

      return Left(FormatFailure('Invalid response format'));
    } on rest_client.ServerFailure catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on rest_client.NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    } on rest_client.AppFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch templates: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TemplateModel>> getTemplateById(String templateId) async {
    try {
      final response = await _restClient.get<dynamic>(
        ApiConst.getTemplateById,
        params: {'templateId': templateId},
      );

      if (response is Map) {
        // Проверяем код ответа, если есть
        if (response.containsKey('code')) {
          final code = response['code'];
          if (code != 200 && code != 0 && code != '200' && code != '0') {
            // Это ошибка, извлекаем сообщение
            final message = response['message'];
            if (message is String) {
              return Left(ServerFailure(message));
            }
            return Left(ServerFailure('Ошибка при получении шаблона'));
          }
        }

        // Если есть поле message, проверяем его тип
        if (response.containsKey('message')) {
          final data = response['message'];
          if (data is Map) {
            return Right(TemplateModel.fromJson(data as Map<String, dynamic>));
          } else if (data is String) {
            // message - это строка ошибки
            return Left(ServerFailure(data));
          }
        }

        // Если есть поле data
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is Map) {
            return Right(TemplateModel.fromJson(data as Map<String, dynamic>));
          }
        }

        // Пытаемся парсить весь response как TemplateModel
        return Right(TemplateModel.fromJson(response as Map<String, dynamic>));
      }

      return Left(FormatFailure('Invalid response format'));
    } on rest_client.ServerFailure catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on rest_client.NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    } on rest_client.AppFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch template: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> createTemplate(TemplateModel template) async {
    try {
      await _restClient.post<dynamic>(
        ApiConst.createTemplate,
        body: template.toJsonFlat(), // Используем плоскую структуру для API
      );

      return const Right(null);
    } on rest_client.ServerFailure catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on rest_client.NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    } on rest_client.AppFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create template: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTemplate(TemplateModel template) async {
    try {
      await _restClient.put<dynamic>(
        ApiConst.updateTemplate,
        body: template.toJsonFlat(), // Используем плоскую структуру для API
      );

      return const Right(null);
    } on rest_client.ServerFailure catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on rest_client.NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    } on rest_client.AppFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update template: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTemplate(String templateId) async {
    try {
      await _restClient.delete<dynamic>(
        ApiConst.deleteTemplate,
        params: {'templateId': templateId},
      );

      return const Right(null);
    } on rest_client.ServerFailure catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on rest_client.NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    } on rest_client.AppFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete template: ${e.toString()}'));
    }
  }
}
