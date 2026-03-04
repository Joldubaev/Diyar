part of 'open_banking_cubit.dart';

/// Sealed-иерархия состояний экрана OpenBanking-оплаты.
sealed class OpenBankingState extends Equatable {
  const OpenBankingState();

  @override
  List<Object?> get props => [];
}

final class OpenBankingInitializing extends OpenBankingState {
  const OpenBankingInitializing();
}

final class OpenBankingReady extends OpenBankingState {
  final String payLinkUrl;
  final PaymentStatusType signalRStatus;

  const OpenBankingReady({
    required this.payLinkUrl,
    required this.signalRStatus,
  });

  OpenBankingReady copyWith({
    String? payLinkUrl,
    PaymentStatusType? signalRStatus,
  }) {
    return OpenBankingReady(
      payLinkUrl: payLinkUrl ?? this.payLinkUrl,
      signalRStatus: signalRStatus ?? this.signalRStatus,
    );
  }

  @override
  List<Object?> get props => [payLinkUrl, signalRStatus];
}

final class OpenBankingSuccess extends OpenBankingState {
  final int amount;

  const OpenBankingSuccess({required this.amount});

  @override
  List<Object?> get props => [amount];
}

final class OpenBankingError extends OpenBankingState {
  final String message;

  const OpenBankingError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class OpenBankingPaymentConfirmed extends OpenBankingState {
  const OpenBankingPaymentConfirmed();
}
