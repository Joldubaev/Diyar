import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/map/map.dart';
import 'package:diyar/features/order/data/models/model.dart';

/// Хелперы для обработки ответов API в OrderRemoteDataSource
class OrderRemoteDataSourceHelpers {
  /// Обрабатывает ответ API для получения геоподсказок
  static Either<Failure, LocationModel> handleGeoSuggestionsResponse(
    dynamic responseData,
    int? statusCode,
  ) {
    if (statusCode == 200) {
      log('Response: $responseData');
      try {
        final model = LocationModel.fromJson(
          responseData is String ? json.decode(responseData) : responseData,
        );
        return Right(model);
      } catch (e, stacktrace) {
        log('Error parsing GeoSuggestions: $e');
        log('Stacktrace: $stacktrace');
        return Left(ServerFailure('Failed to parse geo suggestions: ${e.toString()}', null));
      }
    } else {
      log('Failed to load suggestions: $statusCode');
      return Left(ServerFailure('Failed to load suggestions', statusCode));
    }
  }

  /// Обрабатывает ответ API для создания заказа
  static Either<Failure, String> handleCreateOrderResponse(
    dynamic responseData,
    int? statusCode,
  ) {
    if ([200, 201].contains(statusCode) || [200, 201].contains(responseData?['code'])) {
      return Right(
        responseData?['message']?.toString() ??
            responseData?.toString() ??
            'Order created successfully',
      );
    } else {
      log('Failed to create order: status=$statusCode, data=$responseData');
      final errorMessage = responseData?['message']?.toString() ??
          responseData?.toString() ??
          'Failed to create order (status: $statusCode)';
      return Left(ServerFailure(errorMessage, statusCode));
    }
  }

  /// Обрабатывает ответ API для получения истории заказов
  static Either<Failure, List<String>> handleOrderHistoryResponse(
    dynamic responseData,
    int? statusCode,
  ) {
    if (statusCode == 200) {
      if (responseData != null && responseData['data'] is List) {
        final history = List<String>.from(responseData['data']);
        return Right(history);
      } else {
        log('Unexpected data format for order history: $responseData');
        return const Left(ServerFailure('Unexpected data format for order history', null));
      }
    } else {
      log('Failed to get order history: $statusCode $responseData');
      return Left(
        ServerFailure(
          responseData?['message']?.toString() ?? 'Failed to get order history',
          statusCode,
        ),
      );
    }
  }

  /// Обрабатывает ответ API для получения районов
  static Either<Failure, List<DistrictDataModel>> handleDistrictsResponse(
    dynamic responseData,
    int? statusCode,
  ) {
    if (statusCode == 200) {
      log('Response: $responseData');

      if (responseData is List) {
        final districts = List<DistrictDataModel>.from(
          responseData.map((x) => DistrictDataModel.fromJson(x)),
        );
        return Right(districts);
      } else {
        log('Unexpected data format: $responseData');
        return const Left(ServerFailure('Unexpected data format', null));
      }
    } else {
      log('Error Message: ${responseData['message']}');
      return Left(ServerFailure(responseData['message'] ?? 'Unknown error', statusCode));
    }
  }

  /// Обрабатывает DioException для всех методов
  static Either<Failure, T> handleDioException<T>(DioException e, String operation) {
    log('Error in $operation: ${e.message}');
    log('DioException details:');
    log('  - Request path: ${e.requestOptions.path}');
    log('  - Request data: ${e.requestOptions.data}');
    log('  - Response status: ${e.response?.statusCode}');
    log('  - Response data: ${e.response?.data}');

    if (e.response != null && e.response!.data != null) {
      final errorData = e.response!.data;
      final errorMessage = errorData is Map
          ? (errorData['message']?.toString() ?? errorData.toString())
          : errorData.toString();
      return Left(ServerFailure(errorMessage, e.response?.statusCode));
    }

    return Left(ServerFailure(e.message ?? 'Network error during $operation', e.response?.statusCode));
  }

  /// Обрабатывает общие исключения
  static Either<Failure, T> handleGenericException<T>(Object e, String operation) {
    log('Exception during $operation: ${e.toString()}');
    return Left(ServerFailure('Exception during $operation: ${e.toString()}', null));
  }
}

