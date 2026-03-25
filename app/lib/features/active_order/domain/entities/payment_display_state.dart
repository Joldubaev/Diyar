import 'package:flutter/material.dart';

/// Отображаемый статус оплаты заказа.
/// Маппинг с бэка: New, Await → pending; Successful, Charge → paid; Reject → rejected.
enum PaymentDisplayState {
  paid,
  pending,
  rejected,
  ;

  /// Маппинг сырого значения с бэка (New, Await, Successful, Reject, Charge) в enum.
  static PaymentDisplayState fromRaw(String? raw) {
    switch (raw) {
      case 'Successful':
      case 'Charge':
        return PaymentDisplayState.paid;
      case 'Reject':
        return PaymentDisplayState.rejected;
      case 'New':
      case 'Await':
      default:
        return PaymentDisplayState.pending;
    }
  }
}

extension PaymentDisplayStateX on PaymentDisplayState {
  String get label {
    switch (this) {
      case PaymentDisplayState.paid:
        return 'Оплачена';
      case PaymentDisplayState.pending:
        return 'В ожидании';
      case PaymentDisplayState.rejected:
        return 'Отклонена';
    }
  }

  Color get color {
    switch (this) {
      case PaymentDisplayState.paid:
        return Colors.green;
      case PaymentDisplayState.pending:
        return Colors.orange;
      case PaymentDisplayState.rejected:
        return Colors.red;
    }
  }
}
