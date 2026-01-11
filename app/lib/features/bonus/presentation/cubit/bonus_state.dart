part of 'bonus_cubit.dart';

sealed class BonusState extends Equatable {
  const BonusState();

  @override
  List<Object?> get props => [];
}

final class BonusInitial extends BonusState {
  const BonusInitial();
}

final class BonusQrLoading extends BonusState {
  const BonusQrLoading();
}

final class BonusQrLoaded extends BonusState {
  final QrGenerateEntity qrData;

  const BonusQrLoaded(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

final class BonusQrFailure extends BonusState {
  final String message;

  const BonusQrFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class BonusTransactionsLoading extends BonusState {
  const BonusTransactionsLoading();
}

final class BonusTransactionsLoaded extends BonusState {
  final BonusTransactionResponseEntity response;

  const BonusTransactionsLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

final class BonusTransactionsError extends BonusState {
  final String message;

  const BonusTransactionsError(this.message);

  @override
  List<Object?> get props => [message];
}
