import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() {
  group('AppFailure hierarchy', () {
    test('NoInternetFailure has correct message', () {
      const failure = NoInternetFailure();
      expect(failure.message, 'No internet connection');
      expect(failure.toString(), 'No internet connection');
    });

    test('ServiceUnavailableFailure stores statusCode', () {
      const failure = ServiceUnavailableFailure(statusCode: 503);
      expect(failure.statusCode, 503);
      expect(failure.message, 'Service unavailable');
    });

    test('ServerFailure with ServerErrorBody extracts message', () {
      final body = ServerErrorBody(code: 'VALIDATION', message: 'Invalid phone');
      final failure = ServerFailure<ServerErrorBody>(
        model: body,
        statusCode: 422,
        json: {'error': 'VALIDATION', 'message': 'Invalid phone'},
      );
      expect(failure.message, 'Invalid phone');
      expect(failure.statusCode, 422);
    });

    test('ServerFailure with non-ServerErrorBody returns generic message', () {
      const failure = ServerFailure<String>(
        model: 'raw error',
        statusCode: 500,
        json: {},
      );
      expect(failure.message, 'Server error');
    });

    test('UnknownFailure stores error and stackTrace', () {
      final error = FormatException('bad format');
      final trace = StackTrace.current;
      final failure = UnknownFailure(failure: error, stackTrace: trace);
      expect(failure.message, 'Unknown failure');
      expect(failure.failure, error);
      expect(failure.stackTrace, trace);
    });

    test('NetworkFailure is sealed — exhaustive switch', () {
      const NetworkFailure failure = NoInternetFailure();
      final result = switch (failure) {
        NoInternetFailure() => 'no_internet',
        ServiceUnavailableFailure() => 'unavailable',
        ServerFailure() => 'server',
      };
      expect(result, 'no_internet');
    });
  });

  group('ServerErrorBody', () {
    test('fromJson parses correctly', () {
      final body = ServerErrorBody.fromJson({
        'error': 'NOT_FOUND',
        'message': 'User not found',
      });
      expect(body.code, 'NOT_FOUND');
      expect(body.message, 'User not found');
    });

    test('fromJson handles missing fields', () {
      final body = ServerErrorBody.fromJson({});
      expect(body.code, isNull);
      expect(body.message, 'Unknown server error');
    });
  });

  group('ExtendedError', () {
    test('NoConnectionError is an ExtendedError', () {
      const error = NoConnectionError();
      expect(error, isA<ExtendedError>());
    });

    test('ParseError is an ExtendedError', () {
      const error = ParseError();
      expect(error, isA<ExtendedError>());
    });
  });
}
