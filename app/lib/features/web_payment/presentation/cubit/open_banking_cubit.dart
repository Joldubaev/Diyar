import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diyar/features/web_payment/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'open_banking_state.dart';

@injectable
final class OpenBankingCubit extends Cubit<OpenBankingState> {
  final IOpenBankingRepository _repository;
  final IPaymentStatusSignalRService _signalRService;

  StreamSubscription<PaymentStatusType>? _statusSubscription;
  String? _orderNumber;
  int? _amount;

  OpenBankingCubit(this._repository, this._signalRService)
      : super(const OpenBankingInitializing());

  Future<void> initialize({
    required String orderNumber,
    required int amount,
  }) async {
    _orderNumber = orderNumber;
    _amount = amount;

    final result = await _repository.createPayLink(
      amount: amount,
      orderNumber: orderNumber,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(OpenBankingError(message: failure.message)),
      (payLinkUrl) {
        emit(OpenBankingReady(
          payLinkUrl: payLinkUrl,
          signalRStatus: PaymentStatusType.pending,
        ));
        _connectToSignalR(orderNumber);
      },
    );
  }

  Future<void> _connectToSignalR(String orderNumber) async {
    _statusSubscription = _signalRService.statusStream.listen(
      _onStatusReceived,
      onError: (Object e, StackTrace st) {
        if (isClosed) return;
        final current = state;
        if (current is OpenBankingReady) {
          emit(current.copyWith(signalRStatus: PaymentStatusType.error));
        }
      },
    );
    await _signalRService.connect(orderNumber);
  }

  void _onStatusReceived(PaymentStatusType status) {
    if (isClosed) return;
    if (status == PaymentStatusType.success) {
      _statusSubscription?.cancel();
      _statusSubscription = null;
      final orderNumber = _orderNumber;
      if (orderNumber != null) {
        unawaited(_signalRService.disconnect(orderNumber));
      }
      emit(OpenBankingSuccess(amount: _amount ?? 0));
      return;
    }
    final current = state;
    if (current is OpenBankingReady) {
      emit(current.copyWith(signalRStatus: status));
    }
  }

  void onPaymentConfirmed() {
    if (isClosed) return;
    emit(const OpenBankingPaymentConfirmed());
  }

  Future<void> onUserManuallyConfirmed() async {
    if (isClosed) return;
    await _statusSubscription?.cancel();
    _statusSubscription = null;
    final orderNumber = _orderNumber;
    if (orderNumber != null) {
      await _signalRService.disconnect(orderNumber);
    }
    if (isClosed) return;
    emit(const OpenBankingPaymentConfirmed());
  }

  void onPaymentCallbackReceived(PaymentStatusType status) {
    if (isClosed) return;
    if (status == PaymentStatusType.success) {
      _onStatusReceived(PaymentStatusType.success);
    } else if (status == PaymentStatusType.error) {
      final current = state;
      if (current is OpenBankingReady) {
        emit(current.copyWith(signalRStatus: PaymentStatusType.error));
      }
    }
  }

  @override
  Future<void> close() async {
    await _statusSubscription?.cancel();
    final orderNumber = _orderNumber;
    if (orderNumber != null) {
      await _signalRService.disconnect(orderNumber);
    }
    return super.close();
  }
}
