/// Статус оплаты Open Banking.
enum PaymentStatusType { success, pending, error }

extension PaymentStatusTypeExtension on PaymentStatusType {
  String get title {
    switch (this) {
      case PaymentStatusType.success:
        return 'Платеж осуществлен';
      case PaymentStatusType.pending:
        return 'Платеж в обработке \nожидайте';
      case PaymentStatusType.error:
        return 'Ошибка оплаты';
    }
  }
}

/// Маппинг статусов API ReceiveStatus на PaymentStatusType.
class PaymentStatusTypeMapper {
  static PaymentStatusType fromCode(String code) {
    switch (code) {
      case 'Charge':
      case 'Successful':
        return PaymentStatusType.success;
      case 'Await':
      case 'New':
        return PaymentStatusType.pending;
      case 'Reject':
      default:
        return PaymentStatusType.error;
    }
  }
}
