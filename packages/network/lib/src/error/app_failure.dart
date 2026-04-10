import 'package:equatable/equatable.dart';
import 'package:network/src/error/server_error_body.dart';

/// Unified failure hierarchy for the entire app.
///
/// [AppFailure] is the single base type for all domain-level errors.
/// Use `switch` for exhaustive handling of [NetworkFailure] subtypes.
sealed class AppFailure {
  const AppFailure();
  String get message;

  @override
  String toString() => message;
}

/// Unexpected or unhandled error.
class UnknownFailure extends Equatable implements AppFailure {
  const UnknownFailure({required this.failure, required this.stackTrace});

  final Object failure;
  final StackTrace stackTrace;

  @override
  String get message => 'Unknown failure';

  @override
  String toString() => '$message\n$failure\n$stackTrace';

  @override
  List<Object?> get props => [message, failure, stackTrace];
}

/// Base for all network-related failures. Sealed for exhaustive matching.
sealed class NetworkFailure extends Equatable implements AppFailure {
  const NetworkFailure();

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

/// Device has no internet connection.
class NoInternetFailure extends NetworkFailure {
  const NoInternetFailure();

  @override
  String get message => 'No internet connection';
}

/// Server returned 5xx or is unreachable.
class ServiceUnavailableFailure extends NetworkFailure {
  const ServiceUnavailableFailure({required this.statusCode});

  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String get message => 'Service unavailable';
}

/// Server returned an error response (4xx / 5xx) with a parseable body.
class ServerFailure<ErrorJsonT> extends NetworkFailure {
  const ServerFailure({
    required this.model,
    required this.statusCode,
    required this.json,
  });

  final ErrorJsonT model;
  final Map<String, dynamic> json;
  final int statusCode;

  @override
  String get message {
    if (model is ServerErrorBody) {
      return (model as ServerErrorBody).message;
    }
    return 'Server error';
  }

  @override
  List<Object?> get props => [message, statusCode, model, json];

  @override
  String toString() => '$message\nmodel:\n$model';
}
