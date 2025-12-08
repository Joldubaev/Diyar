import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// General failures
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, [this.statusCode]);

  const ServerFailure.withStatusCode(super.message, this.statusCode);
}

/// Network-related failures (timeout, connection errors, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Format/parsing failures
class FormatFailure extends Failure {
  const FormatFailure(super.message);
}

/// Cache/storage failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Cancel token failure
class CancelTokenFailure extends Failure {
  final int? statusCode;

  const CancelTokenFailure(super.message, this.statusCode);
}
