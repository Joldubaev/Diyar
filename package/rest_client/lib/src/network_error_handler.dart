import 'package:dio/dio.dart';
import 'package:rest_client/src/network.dart';

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
      final model = _tryParseServerFailure(response);

      if (model.code?.toLowerCase() == "internal_server_error") {
        throw ServiceUnavailableFailure(statusCode: statusCode);
      }

      throw ServerFailure<ServerErrorBody>(
          model: model, statusCode: statusCode, json: response?.data ?? {});
    } catch (e, s) {
      throw UnknownFailure(failure: e, stackTrace: s);
    }
  }

  ServerErrorBody _tryParseServerFailure(Response? response) {
    try {
      if (response?.data is Map<String, dynamic>) {
        return ServerErrorBody.fromJson(response!.data);
      }
      return ServerErrorBody(
        code: null,
        message: "Unexpected error format",
      );
    } catch (e) {
      throw ServiceUnavailableFailure(statusCode: response?.statusCode ?? -1);
    }
  }
}
