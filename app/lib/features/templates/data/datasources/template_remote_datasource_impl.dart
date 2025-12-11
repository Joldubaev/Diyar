import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rest_client/rest_client.dart' as rest_client;
// ignore: implementation_imports
import 'package:rest_client/src/data_parser.dart';

import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/data/model/template_model.dart';

import 'template_remote_data_source.dart';

/// Кастомный парсер для списка шаблонов, обрабатывающий структуру API
class TemplatesListParser implements DataParser<List<TemplateModel>> {
  @override
  List<TemplateModel> parse(dynamic data) {
    // Если данные - это список напрямую
    if (data is List) {
      return data.map((json) => TemplateModel.fromJson(json as Map<String, dynamic>)).toList();
    }

    // Если данные - это Map
    if (data is Map) {
      // Проверяем код ответа
      if (data.containsKey('code')) {
        final code = data['code'];
        final message = data['message'];

        // Если код 404 и сообщение говорит о том, что шаблоны не найдены
        if ((code == 404 || code == '404') && message is String) {
          if (ApiErrorUtils.isNotFoundMessage(message)) {
            return [];
          }
        }

        // Если код не успешный, бросаем ошибку
        final isSuccessCode = code == 200 || code == 0 || code == '200' || code == '0';
        if (!isSuccessCode) {
          if (message is String) {
            throw ServerFailure(message);
          }
          throw ServerFailure('Ошибка при получении данных');
        }
      }

      // Пытаемся извлечь список из поля message
      if (data.containsKey('message')) {
        final messageData = data['message'];
        if (messageData is List) {
          return messageData.map((json) => TemplateModel.fromJson(json as Map<String, dynamic>)).toList();
        } else if (messageData is String) {
          // Если message - это ошибка о том, что данные не найдены
          if (ApiErrorUtils.isNotFoundMessage(messageData)) {
            return [];
          }
          throw ServerFailure(messageData);
        }
      }

      // Пытаемся извлечь список из поля data
      if (data.containsKey('data')) {
        final dataField = data['data'];
        if (dataField is List) {
          return dataField.map((json) => TemplateModel.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
    }

    throw FormatFailure('Invalid response format');
  }
}

/// Кастомный парсер для одиночного шаблона, обрабатывающий структуру API
class TemplateObjectParser implements DataParser<TemplateModel> {
  @override
  TemplateModel parse(dynamic data) {
    if (data is Map) {
      // Проверяем код ответа
      if (data.containsKey('code')) {
        final code = data['code'];
        final isSuccessCode = code == 200 || code == 0 || code == '200' || code == '0';
        if (!isSuccessCode) {
          final message = data['message'];
          if (message is String) {
            throw ServerFailure(message);
          }
          throw ServerFailure('Ошибка при получении данных');
        }
      }

      // Пытаемся извлечь объект из поля message
      if (data.containsKey('message')) {
        final messageData = data['message'];
        if (messageData is Map) {
          return TemplateModel.fromJson(messageData as Map<String, dynamic>);
        } else if (messageData is String) {
          throw ServerFailure(messageData);
        }
      }

      // Пытаемся извлечь объект из поля data
      if (data.containsKey('data')) {
        final dataField = data['data'];
        if (dataField is Map) {
          return TemplateModel.fromJson(dataField as Map<String, dynamic>);
        }
      }

      // Пытаемся парсить весь response как объект
      return TemplateModel.fromJson(data as Map<String, dynamic>);
    }

    throw FormatFailure('Invalid response format');
  }
}

@LazySingleton(as: TemplateRemoteDataSource)
class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  final rest_client.RestClient _restClient;

  TemplateRemoteDataSourceImpl(@Named('authRestClient') this._restClient);

  /// Универсальный метод для обработки исключений и обертывания в Either
  Future<Either<Failure, T>> _callAndHandleErrors<T>(
    Future<T> Function() call, {
    T? Function(rest_client.ServerFailure)? on404,
  }) async {
    try {
      final result = await call();
      return Right(result);
    } on rest_client.ServerFailure catch (e) {
      // Если передан обработчик для 404, используем его
      if (e.statusCode == 404 && on404 != null) {
        final result = on404(e);
        if (result != null) {
          return Right(result);
        }
      }
      return Left(ServerFailure(e.message, e.statusCode));
    } on rest_client.NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    } on rest_client.AppFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TemplateModel>>> getAllTemplates() async {
    return _callAndHandleErrors(
      () async {
        return await _restClient.get<List<TemplateModel>>(
          ApiConst.getAllTemplates,
          parser: TemplatesListParser(),
        );
      },
      on404: (e) {
        final messageFromJson = e.json['message'];
        final message = messageFromJson is String ? messageFromJson : e.message;

        // Используем внешнюю утилиту для проверки сообщения об ошибке
        if (ApiErrorUtils.isNotFoundMessage(message)) {
          return <TemplateModel>[];
        }
        return null;
      },
    );
  }

  @override
  Future<Either<Failure, TemplateModel>> getTemplateById(String templateId) async {
    return _callAndHandleErrors(
      () async {
        return await _restClient.get<TemplateModel>(
          ApiConst.getTemplateById,
          params: {'templateId': templateId},
          parser: TemplateObjectParser(),
        );
      },
    );
  }

  @override
  Future<Either<Failure, void>> createTemplate(TemplateModel template) async {
    return _callAndHandleErrors<void>(
      () async {
        await _restClient.post<dynamic>(
          ApiConst.createTemplate,
          body: template.toJsonFlat(),
        );
      },
    );
  }

  @override
  Future<Either<Failure, void>> updateTemplate(TemplateModel template) async {
    return _callAndHandleErrors<void>(
      () async {
        await _restClient.put<dynamic>(
          ApiConst.updateTemplate,
          body: template.toJsonFlat(),
        );
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteTemplate(String templateId) async {
    return _callAndHandleErrors<void>(
      () async {
        await _restClient.delete<dynamic>(
          ApiConst.deleteTemplate,
          params: {'templateId': templateId},
        );
      },
    );
  }
}
