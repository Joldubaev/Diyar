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

  const ServerFailure(super.message, this.statusCode);
}

/// Cancel token failure
class CancelTokenFailure extends Failure {
  final int? statusCode;

  const CancelTokenFailure(super.message, this.statusCode);
}
