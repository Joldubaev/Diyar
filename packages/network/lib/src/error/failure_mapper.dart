import 'package:dio/dio.dart';
import 'package:network/src/error/app_failure.dart';
import 'package:network/src/error/extended_error.dart';
import 'package:network/src/error/server_error_body.dart';

/// Converts raw exceptions into typed [AppFailure] instances.
abstract interface class NetworkErrorHandler {
  Future<T> tryCall<T>(Future<T> Function() call);
}

class NetworkErrorHandlerImpl implements NetworkErrorHandler {
  @override
  Future<T> tryCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ExtendedError catch (e, s) {
      return switch (e) {
        NoConnectionError() => throw const NoInternetFailure(),
        ParseError() => throw UnknownFailure(failure: e, stackTrace: s),
      };
    } on DioException catch (exception) {
      final statusCode = exception.response?.statusCode ?? -1;

      if (statusCode == -1) {
        throw ServiceUnavailableFailure(statusCode: statusCode);
      }

      final response = exception.response;
      final model = _tryParseServerError(response);

      if (model.code?.toLowerCase() == 'internal_server_error') {
        throw ServiceUnavailableFailure(statusCode: statusCode);
      }

      throw ServerFailure<ServerErrorBody>(
        model: model,
        statusCode: statusCode,
        json: response?.data is Map<String, dynamic>
            ? response!.data as Map<String, dynamic>
            : <String, dynamic>{},
      );
    } catch (e, s) {
      throw UnknownFailure(failure: e, stackTrace: s);
    }
  }

  ServerErrorBody _tryParseServerError(Response<dynamic>? response) {
    try {
      if (response?.data is Map<String, dynamic>) {
        return ServerErrorBody.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
      return ServerErrorBody(code: null, message: 'Unexpected error format');
    } catch (_) {
      throw ServiceUnavailableFailure(
        statusCode: response?.statusCode ?? -1,
      );
    }
  }
}
