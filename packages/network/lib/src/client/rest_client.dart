import 'dart:async';

import 'package:dio/dio.dart';
import 'package:network/src/error/extended_error.dart';
import 'package:network/src/error/failure_mapper.dart';
import 'package:network/src/network_info.dart';
import 'package:network/src/parser/data_parser.dart';

/// Abstract HTTP client with typed error handling.
///
/// Subclass [AuthRestClient] or [UnAuthRestClient] to get pre-configured
/// interceptors. All HTTP methods delegate to [request], which checks
/// connectivity and maps errors via [NetworkErrorHandler].
abstract class RestClient {
  RestClient(
    this._dio, {
    required NetworkErrorHandler errorHandler,
  }) : _errorHandler = errorHandler;

  final Dio _dio;
  final NetworkInfo _networkInfo = NetworkInfoImpl();
  final NetworkErrorHandler _errorHandler;

  Future<T> get<T>(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    DataParser<T>? parser,
  }) =>
      request(
        (dio) => dio.get(url,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken),
        parser: parser,
      );

  Future<T> post<T>(
    String url, {
    Object? body,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    DataParser<T>? parser,
  }) =>
      request(
        (dio) => dio.post(url,
            data: body,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken),
        parser: parser,
      );

  Future<T> put<T>(
    String url, {
    Object? body,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    DataParser<T>? parser,
  }) =>
      request(
        (dio) => dio.put(url,
            data: body,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken),
        parser: parser,
      );

  Future<T> delete<T>(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    DataParser<T>? parser,
  }) =>
      request(
        (dio) => dio.delete(url,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken),
        parser: parser,
      );

  Future<T> patch<T>(
    String url, {
    Object? body,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    DataParser<T>? parser,
  }) =>
      request(
        (dio) => _dio.patch(url,
            data: body,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken),
        parser: parser,
      );

  Future<T> request<T>(
    Future<Response<dynamic>> Function(Dio dio) call, {
    required DataParser<T>? parser,
  }) async {
    return _errorHandler.tryCall<T>(() async {
      if (await _networkInfo.isConnected) {
        final response = await call(_dio);
        final data = response.data;
        if (parser != null) return parser.parse(data);
        return data as T;
      } else {
        throw const NoConnectionError();
      }
    });
  }
}
