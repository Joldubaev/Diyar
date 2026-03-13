enum PaymentStatus {
  newOrder('New'),
  await_('Await'),
  successful('Successful'),
  charge('Charge'),
  reject('Reject');

  const PaymentStatus(this.value);
  final String value;

  static PaymentStatus? fromString(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim().toLowerCase();
    for (final e in PaymentStatus.values) {
      if (e.value.toLowerCase() == normalized) return e;
    }
    return null;
  }

  bool get isPaid => this == PaymentStatus.successful || this == PaymentStatus.charge;
}

enum PaymentMethod {
  cash,
  card;

  static PaymentMethod fromString(String? value) {
    if (value == null) return PaymentMethod.card;
    final lower = value.toLowerCase();
    if (lower.contains('cash') || lower.contains('налич')) return PaymentMethod.cash;
    return PaymentMethod.card;
  }

  bool get isCash => this == PaymentMethod.cash;
}
