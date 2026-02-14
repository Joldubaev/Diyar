import 'package:equatable/equatable.dart';

/// Базовый контракт ошибки для Domain (Clean Architecture).
/// Реализации для сети — в core/network/error/failures.dart.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}
