import 'package:bloc/bloc.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/data/model/get_user_moderl.dart';
import 'package:meta/meta.dart';

part 'curier_state.dart';

class CurierCubit extends Cubit<CurierState> {
  CurierCubit(this.curierRepository) : super(CurierInitial());

  final CurierRepository curierRepository;

  void getUser() async {
    emit(GetUserLoading());
    try {
      final user = await curierRepository.getUser();
      emit(GetUserLoaded(user));
    } catch (e) {
      emit(GetUserError('Error'));
    }
  }

  void getCuriers() async {
    emit(GetCourierActualOrdersLoading());
    try {
      final curiers = await curierRepository.getCuriers();
      emit(GetCourierActualOrdersLoaded(curiers));
    } catch (e) {
      emit(GetCourierActualOrdersError('Error'));
    }
  }

  Future getFinishOrder(int orderId) async {
    try {
      await curierRepository.getFinishOrder(orderId);
    } catch (e) {
      emit(GetCourierActualOrdersError('Error'));
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
