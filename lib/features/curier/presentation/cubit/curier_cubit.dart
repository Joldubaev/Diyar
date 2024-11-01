import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:meta/meta.dart';

part 'curier_state.dart';

class CurierCubit extends Cubit<CurierState> {
  CurierCubit(this.curierRepository) : super(CurierInitial());

  final CurierRepository curierRepository;
  GetUserModel? user;

  Future getUser() async {
    emit(GetUserLoading());
    try {
      user = await curierRepository.getUser();
      if (user != null) {
        emit(GetUserLoaded(user!));
      } else {
        emit(GetUserError('User data is null'));
      }
    } catch (e) {
      emit(GetUserError(e.toString()));
    }
  }

  void getCurierOrders() async {
    emit(GetCourierOrdersLoading());
    try {
      final curiers = await curierRepository.getCurierOrders();
      log('Orders fetched successfully');
      emit(GetCourierOrdersLoaded(curiers));
    } catch (e) {
      log('Error fetching orders: ${e.toString()}');
      emit(GetCourierOrdersError(e.toString()));
    }
  }

  Future getFinishOrder(int orderId) async {
    emit(GetFinishedOrdersLoading());
    try {
      await curierRepository.getFinishOrder(orderId);
      emit(GetFinishedOrdersLoaded());
    } catch (e) {
      emit(GetFinishedOrdersError());
      log('Error finishing order: ${e.toString()}');
    }
  }

  void getCurierHistory() async {
    emit(GetCurierHistoryLoading());
    try {
      final curiers = await curierRepository.getCurierHistory();
      emit(GetCurierHistoryLoaded(curiers));
    } catch (e) {
      emit(GetCurierHistoryError(e.toString()));
    }
  }
}
