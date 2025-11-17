import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'curier_state.dart';

@injectable
class CurierCubit extends Cubit<CurierState> {
  CurierCubit(this.curierRepository) : super(CurierInitial());

  final CurierRepository curierRepository;
  GetUserEntity? user;

  Future getUser() async {
    emit(GetUserLoading());
    final result = await curierRepository.getUser();
    result.fold(
      (failure) => emit(GetUserError(failure.message)),
      (userEntity) {
        user = userEntity;
        emit(GetUserLoaded(user!));
      },
    );
  }

  void getCurierOrders() async {
    emit(GetCourierOrdersLoading());
    final result = await curierRepository.getCurierOrders();
    result.fold(
      (failure) => emit(GetCourierOrdersError(failure.message)),
      (curiers) {
        log('Orders fetched successfully');
        emit(GetCourierOrdersLoaded(curiers));
      },
    );
  }

  Future getFinishOrder(int orderId) async {
    emit(GetFinishedOrdersLoading());
    final result = await curierRepository.getFinishOrder(orderId);
    result.fold(
      (failure) {
        emit(GetFinishedOrdersError());
        log('Error finishing order: ${failure.message}');
      },
      (_) => emit(GetFinishedOrdersLoaded()),
    );
  }

  void getCurierHistory() async {
    emit(GetCurierHistoryLoading());
    final result = await curierRepository.getCurierHistory();
    result.fold(
      (failure) => emit(GetCurierHistoryError(failure.message)),
      (curiers) => emit(GetCurierHistoryLoaded(curiers)),
    );
  }
}
