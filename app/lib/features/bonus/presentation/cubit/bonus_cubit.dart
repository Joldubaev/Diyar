import 'package:bloc/bloc.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'bonus_state.dart';

@injectable
class BonusCubit extends Cubit<BonusState> {
  final GenerateQrUseCase _generateQrUseCase;

  BonusCubit(this._generateQrUseCase) : super(BonusInitial());

  Future<void> generateQr() async {
    final isAuth = UserHelper.isAuth();
    if (!isAuth) {
      emit(BonusQrFailure('Необходима авторизация для генерации QR кода'));
      return;
    }

    emit(BonusQrLoading());
    final result = await _generateQrUseCase();
    result.fold(
      (failure) => emit(BonusQrFailure(failure.message)),
      (qrData) => emit(BonusQrLoaded(qrData)),
    );
  }
}
