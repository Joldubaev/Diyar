import 'package:diyar/features/payments/domain/domain.dart';

class QrCodeModel {
  final String? qrData;
  final String? transactionId;

  QrCodeModel({
    this.qrData,
    this.transactionId,
  });

  QrCodeModel copyWith({
    String? qrData,
    String? transactionId,
  }) =>
      QrCodeModel(
        qrData: qrData ?? this.qrData,
        transactionId: transactionId ?? this.transactionId,
      );

  Map<String, dynamic> toJson() {
    return {
      'qrData': qrData,
      'transactionId': transactionId,
    };
  }

  factory QrCodeModel.fromJson(Map<String, dynamic> map) {
    return QrCodeModel(
      qrData: map['qrData'],
      transactionId: map['transactionId'],
    );
  }

  factory QrCodeModel.fromEntity(QrCodeEntity entity) {
    return QrCodeModel(
      qrData: entity.qrData,
      transactionId: entity.transactionId,
    );
  }
  QrCodeEntity toEntity() {
    return QrCodeEntity(
      qrData: qrData,
      transactionId: transactionId,
    );
  }
}
