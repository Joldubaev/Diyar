import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() {
  late NetworkErrorHandlerImpl handler;

  setUp(() {
    handler = NetworkErrorHandlerImpl();
  });

  group('NetworkErrorHandlerImpl.tryCall', () {
    test('returns value on success', () async {
      final result = await handler.tryCall(() async => 42);
      expect(result, 42);
    });

    test('throws NoInternetFailure on NoConnectionError', () async {
      expect(
        () => handler.tryCall(() async => throw const NoConnectionError()),
        throwsA(isA<NoInternetFailure>()),
      );
    });

    test('throws UnknownFailure on ParseError', () async {
      expect(
        () => handler.tryCall(() async => throw const ParseError()),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('throws ServiceUnavailableFailure on DioException with no response', () async {
      expect(
        () => handler.tryCall(() async => throw DioException(
              requestOptions: RequestOptions(path: '/test'),
              type: DioExceptionType.connectionTimeout,
            )),
        throwsA(isA<ServiceUnavailableFailure>()),
      );
    });

    test('throws ServerFailure on DioException with error response', () async {
      expect(
        () => handler.tryCall(() async => throw DioException(
              requestOptions: RequestOptions(path: '/test'),
              response: Response(
                requestOptions: RequestOptions(path: '/test'),
                statusCode: 422,
                data: {'error': 'VALIDATION', 'message': 'Bad input'},
              ),
            )),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('throws ServiceUnavailableFailure on internal_server_error code', () async {
      expect(
        () => handler.tryCall(() async => throw DioException(
              requestOptions: RequestOptions(path: '/test'),
              response: Response(
                requestOptions: RequestOptions(path: '/test'),
                statusCode: 500,
                data: {'error': 'internal_server_error', 'message': 'Oops'},
              ),
            )),
        throwsA(isA<ServiceUnavailableFailure>()),
      );
    });

    test('throws UnknownFailure on arbitrary exception', () async {
      expect(
        () => handler.tryCall(() async => throw Exception('random')),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });
}
