import 'package:bloc/bloc.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'bonus_state.dart';

@injectable
class BonusCubit extends Cubit<BonusState> {
  final GenerateQrUseCase _generateQrUseCase;
  final BonusRepository _bonusRepository;

  BonusCubit(this._generateQrUseCase, this._bonusRepository) : super(BonusInitial());

  Future<void> generateQr() async {
    if (state is BonusQrLoading) return;
    if (!UserHelper.isAuth()) {
      emit(const BonusQrFailure('Необходима авторизация'));
      return;
    }

    emit(BonusQrLoading());
    final result = await _generateQrUseCase();
    if (isClosed) return;

    result.fold(
      (failure) => emit(BonusQrFailure(failure.message)),
      (qrData) => emit(BonusQrLoaded(qrData)),
    );
  }

  Future<void> getBonusTransactions({
    int page = 1,
    int pageSize = 50,
    String? userId,
    String? transactionType,
    String? dateFrom,
    String? dateTo,
  }) async {
    if (state is BonusTransactionsLoading) return;
    if (!UserHelper.isAuth()) {
      emit(const BonusTransactionsError('Необходима авторизация'));
      return;
    }

    emit(BonusTransactionsLoading());
    final result = await _bonusRepository.getBonusTransactions(
      page: page,
      pageSize: pageSize,
      userId: userId,
      transactionType: transactionType,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(BonusTransactionsError(failure.message)),
      (response) => emit(BonusTransactionsLoaded(response)),
    );
  }

  void reset() => emit(BonusInitial());
}
