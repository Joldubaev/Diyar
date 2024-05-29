import 'package:equatable/equatable.dart';

/// Represents a failure in the application.
abstract class Failure extends Equatable {
  final String message;

  /// Constructs a [Failure] with the given [message].
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents a failure caused by a server error.
class ServerFailure extends Failure {
  /// Constructs a [ServerFailure] with the given [message].
  const ServerFailure(String message) : super(message);
}

/// Represents a failure caused by a connection error.
class ConnectionFailure extends Failure {
  /// Constructs a [ConnectionFailure] with the given [message].
  const ConnectionFailure(String message) : super(message);
}

/// Represents a failure caused by a database error.
class DatabaseFailure extends Failure {
  /// Constructs a [DatabaseFailure] with the given [message].
  const DatabaseFailure(String message) : super(message);
}

// import 'package:equatable/equatable.dart';

// abstract class Failure extends Equatable {}

// class OfflineFailure extends Failure {
//   @override
//   List<Object?> get props => [];
// }
// class ServerFailure extends Failure {
//   @override
//   List<Object?> get props => [];
// }
// class WeekPassFailure extends Failure {
//   @override
//   List<Object?> get props => [];
// }
// class ExistedAccountFailure extends Failure {
//   @override
//   List<Object?> get props => [];
// }

// class NoUserFailure extends Failure {
//   @override
//   List<Object?> get props => [];
// }
// class WrongPasswordFailure extends Failure {
//   @override
//   List<Object?> get props => [];
// }
// class UnmatchedPassFailure extends Failure{
//   @override
//   List<Object?> get props => throw UnimplementedError();
// }
// class NotLoggedInFailure extends Failure{
//   @override
//   List<Object?> get props => throw UnimplementedError();
// }
// class EmailVerifiedFailure extends Failure{
//   @override
//   List<Object?> get props => throw UnimplementedError();
// }
// class TooManyRequestsFailure extends Failure{
//   @override
//   List<Object?> get props => throw UnimplementedError();
// }
