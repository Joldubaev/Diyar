part of 'pick_up_cubit.dart';

@immutable
sealed class PickUpState {}

final class PickUpInitial extends PickUpState {}

final class CreatePickUpOrderLoading extends PickUpState {}

final class CreatePickUpOrderLoaded extends PickUpState {
  final String message;
  CreatePickUpOrderLoaded(this.message);
}

final class CreatePickUpOrderError extends PickUpState {
  final String message;
  CreatePickUpOrderError(this.message);
}
