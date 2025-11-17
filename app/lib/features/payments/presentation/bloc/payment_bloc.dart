import 'package:bloc/bloc.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/payments/presentation/presentation.dart';
import 'package:equatable/equatable.dart';
import 'package:diyar/features/payments/domain/domain.dart';
import 'package:injectable/injectable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final MegaCheckUseCase checkUseCase;
  final MegaInitiateUsecase initiateUseCase;
  final MegaStatusUsecase statusUseCase;
  final QrCodeUsecase qrGenerateUseCase;
  final MbankInitiateUsecase mbankInitiateUsecase;
  final MbankConfimUsecase mbankConfimUsecase;
  final MbankStatusUsecase mbankStatusUsecase;

  PaymentBloc(
    this.checkUseCase,
    this.initiateUseCase,
    this.statusUseCase,
    this.qrGenerateUseCase,
    this.mbankInitiateUsecase,
    this.mbankConfimUsecase,
    this.mbankStatusUsecase,
  ) : super(PaymentInitial()) {
    on<CheckPaymentMegaEvent>(_onCheckPaymentMega);
    on<InitiatePaymentMegaEvent>(_onInitiatePaymentMega);
    on<CheckPaymentStatusEvent>(_onCheckPaymentStatus);
    on<GenerateQrCodeEvent>(_onGenerateQrCode);
    on<InitiateMbankEvent>(_onInitiateMbank);
    on<ConfirmMbankEvent>(_onConfirmMbank);
    on<CheckMbankStatusEvent>(_onCheckMbankStatus);
    on<CheckQrCodeStatusEvent>(_onCheckQrCodeStatus);
    on<ClearQrCodeEvent>((event, emit) {
      emit(PaymentInitial());
    });
  }

  Future<void> _onCheckPaymentMega(
    CheckPaymentMegaEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await checkUseCase(event.entity);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (checkResult) => emit(PaymentCheckSuccess(checkResult)),
    );
  }

  Future<void> _onInitiatePaymentMega(
    InitiatePaymentMegaEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await initiateUseCase.megaInitiate(event.entity);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (url) => emit(PaymentInitiateSuccess()),
    );
  }

  ///Mbank
  Future<void> _onInitiateMbank(
    InitiateMbankEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentMbankLoading());
    final result = await mbankInitiateUsecase.repository.mbankInitiate(event.entity);
    result.fold(
      (failure) => emit(PaymentMbankError(failure.message)),
      (url) => emit(PaymentMbankSuccess(url)),
    );
  }

  Future<void> _onConfirmMbank(
    ConfirmMbankEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentMbankLoading());
    final result = await mbankConfimUsecase.repository.mbankConfirm(event.entity);
    result.fold(
      (failure) => emit(PaymentMbankError(failure.message)),
      (url) => emit(PaymentMbankSuccess(url)),
    );
  }

  Future<void> _onCheckMbankStatus(
    CheckMbankStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentMbankLoading());
    final result = await mbankStatusUsecase.repository.mbankStatus(event.transactionId);
    result.fold(
      (failure) {
        // Получаем статус из кода ошибки, если есть
        final code = failure is ServerFailure ? failure.statusCode.toString() : null;
        final statusEnum = code != null ? PaymentStatusMapper.fromCode(code) : PaymentStatusEnum.unknown;
        emit(PaymentMbankError(failure.message, status: statusEnum));
      },
      (statusString) {
        // Тут statusString — это строка, например "CHARGE" или "PAYMENT_SUCCESS"
        // Получаем статус и сообщение для Success
        final statusEnum = PaymentStatusMapper.fromCode("200"); // или из ответа, если приходит code
        final message = PaymentStatusMapper.message(statusEnum, statusString);
        emit(PaymentMbankStatusSuccess(
          statusEnum: statusEnum,
          message: message,
        ));
      },
    );
  }

  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await statusUseCase.megaStatus(event.orderNumber);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (status) => emit(PaymentStatusSuccess(status)),
    );
  }

  Future<void> _onGenerateQrCode(
    GenerateQrCodeEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await qrGenerateUseCase(event.amount);
    result.fold(
      (failure) => emit(PaymentQrCodeError(failure.message)),
      (qrCode) => emit(PaymentQrCodeSuccess(qrCode)),
    );
  }

  Future<void> _onCheckQrCodeStatus(
    CheckQrCodeStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await qrGenerateUseCase.repository.qrCheckStatus(event.transactionId, event.orderNumber);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (status) => emit(PaymentQrCodeStatusSuccess(status)),
    );
  }
}
