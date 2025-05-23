import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:diyar/features/pick_up/domain/entities/pickup_order_entity.dart';
import 'package:diyar/features/pick_up/domain/repositories/pick_up_repositories.dart';

part 'pick_up_state.dart';

class PickUpCubit extends Cubit<PickUpState> {
  final PickUpRepositories _pickUpRepository;

  PickUpCubit(this._pickUpRepository) : super(PickUpInitial());

  Future<void> submitPickupOrder(PickupOrderEntity order) async {
    emit(CreatePickUpOrderLoading());
    try {
      final result = await _pickUpRepository.getPickupOrder(order);
      result.fold(
        (failure) => emit(CreatePickUpOrderError(failure.message)),
        (entity) => emit(CreatePickUpOrderLoaded(entity)),
      );
    } catch (e) {
      emit(CreatePickUpOrderError(e.toString()));
    }
  }
}
