import 'package:equatable/equatable.dart';

class QrCodeEntity extends Equatable {
  final String? qrData;
  final String? transactionId;

  const QrCodeEntity({
    this.qrData,
    this.transactionId,
  });

  @override
  List<Object?> get props => [
        qrData,
        transactionId,
      ];
}
