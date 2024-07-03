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
      emit(GetUserLoaded(user!));
    } catch (e) {
      emit(GetUserError('Error'));
    }
  }

  void getCurierOrders() async {
    emit(GetCourierOrdersLoading());
    try {
      final curiers = await curierRepository.getCurierOrders();
      emit(GetCourierOrdersLoaded(curiers));
    } catch (e) {
      emit(GetCourierOrdersError('Error'));
    }
  }

  Future getFinishOrder(int orderId) async {
    emit(GetFinishedOrdersLoading());
    try {
      await curierRepository.getFinishOrder(orderId);
      emit(GetFinishedOrdersLoaded());
    } catch (e) {
      emit(GetFinishedOrdersError());
    }
  }

  void getCurierHistory() async {
    emit(GetCurierHistoryLoading());
    try {
      final curiers = await curierRepository.getCurierHistory();
      emit(GetCurierHistoryLoaded(curiers));
    } catch (e) {
      emit(GetCurierHistoryError('Error'));
    }
  }
}
