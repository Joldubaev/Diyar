enum PaymentStatusType { success, pending, error }

class PaymentStatusTypeMapper {
  static PaymentStatusType fromCode(String code) {
    switch (code) {
      case "Charge":
      case 'Successful':
        return PaymentStatusType.success;
      case "Await":
        return PaymentStatusType.pending;
      case "Reject":
      default:
        return PaymentStatusType.error;
    }
  }
}

extension PaymentStatusTypeExtension on PaymentStatusType {
  String get title {
    switch (this) {
      case PaymentStatusType.success:
        return 'Платеж осуществлен';
      case PaymentStatusType.pending:
        return 'Платеж в обработке';
      case PaymentStatusType.error:
      return 'Ошибка оплаты';
    }
  }

  String get iconPath {
    switch (this) {
      case PaymentStatusType.success:
        return 'assets/icons/success.svg';
      case PaymentStatusType.pending:
        return 'assets/icons/await.svg';
      case PaymentStatusType.error:
      return 'assets/icons/cancel.svg';
    }
  }
}
