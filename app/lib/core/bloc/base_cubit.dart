import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' show Either;

import 'package:diyar/core/error/failure.dart';

/// Base cubit with safe emission and Either handling utilities.
///
/// Prevents emitting after close and eliminates repetitive
/// `result.fold()` + `if (isClosed) return;` boilerplate.
abstract class BaseCubit<S> extends Cubit<S> {
  BaseCubit(super.initialState);

  /// Emits [state] only if the cubit is still open.
  void safeEmit(S state) {
    if (!isClosed) emit(state);
  }

  /// Executes an [Either]-returning [call] with standard loading/success/error flow.
  ///
  /// Usage:
  /// ```dart
  /// await handleEither(
  ///   call: () => _repository.getData(),
  ///   onLoading: () => MyLoading(),
  ///   onSuccess: (data) => MyLoaded(data),
  ///   onFailure: (f) => MyError(f.message),
  /// );
  /// ```
  Future<void> handleEither<T>({
    required Future<Either<Failure, T>> Function() call,
    required S Function() onLoading,
    required S Function(T data) onSuccess,
    required S Function(Failure failure) onFailure,
  }) async {
    safeEmit(onLoading());
    final result = await call();
    if (isClosed) return;
    result.fold(
      (f) => safeEmit(onFailure(f)),
      (d) => safeEmit(onSuccess(d)),
    );
  }
}
