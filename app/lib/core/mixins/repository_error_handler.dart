import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';

mixin RepositoryErrorHandler {
  /// Обертка для безопасного выполнения запросов в репозиториях
  Future<Either<Failure, T>> makeRequest<T>(Future<T> Function() request) async {
    try {
      final result = await request();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        e.message ?? 'Server Error',
        e.statusCode,
      ));
    } on DioException catch (e) {
      String? errorMessage;
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        errorMessage = data['message']?.toString();
      }
      return Left(NetworkFailure(
        errorMessage ?? e.message ?? 'Network Error',
      ));
    } on FormatException catch (e) {
      return Left(FormatFailure('Data parsing error: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e', null));
    }
  }
}
