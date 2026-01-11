import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, [this.statusCode]);

  /// [Senior Protocol V5] Централизованная обработка ошибок Dio
  factory ServerFailure.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Время ожидания запроса истекло', 408);
      
      case DioExceptionType.badResponse:
        // Извлекаем сообщение об ошибке от сервера (зависит от структуры твоего API)
        final dynamic data = e.response?.data;
        String message = 'Произошла ошибка сервера';
        
        if (data is Map) {
          message = data['message']?.toString() ?? 
                    data['error']?.toString() ?? 
                    message;
        }
        
        return ServerFailure(message, e.response?.statusCode);

      case DioExceptionType.cancel:
        return const ServerFailure('Запрос был отменен', null);

      case DioExceptionType.connectionError:
        return const ServerFailure('Ошибка подключения к интернету');

      default:
        return const ServerFailure('Непредвиденная ошибка сети');
    }
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class FormatFailure extends Failure {
  const FormatFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class CancelTokenFailure extends Failure {
  final int? statusCode;
  const CancelTokenFailure(super.message, this.statusCode);
}