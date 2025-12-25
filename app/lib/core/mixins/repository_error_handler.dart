import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/network/error/failures.dart';

mixin RepositoryErrorHandler {
  /// Обертка для безопасного выполнения запросов в репозиториях
  Future<Either<Failure, T>> makeRequest<T>(Future<T> Function() request) async {
    try {
      final result = await request();
      return Right(result);
    } on DioException catch (e) {
      String? errorMessage;
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        errorMessage = data['message']?.toString();
      }
      return Left(ServerFailure(
        errorMessage ?? e.message ?? 'Server Error',
        e.response?.statusCode,
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure('Data parsing error: ${e.message}', null));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e', null));
    }
  }
}
