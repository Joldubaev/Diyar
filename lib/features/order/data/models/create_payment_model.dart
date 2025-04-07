class PaymentModel {
  final int amount;
  final int orderNumber;
  final String phone;
  final String status;
  final String userName;

  PaymentModel({
    required this.amount,
    required this.orderNumber,
    required this.phone,
    required this.status,
    required this.userName,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      amount: json["amount"] ?? 0,
      orderNumber: json["orderNumber"] ?? 0,
      phone: json["phone"] ?? "",
      status: json["status"] ?? "",
      userName: json["userName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "orderNumber": orderNumber,
      "phone": phone,
      "status": status,
      "userName": userName,
    };
  }

  PaymentModel copyWith({
    int? amount,
    int? orderNumber,
    String? phone,
    String? status,
    String? userName,
  }) {
    return PaymentModel(
      amount: amount ?? this.amount,
      orderNumber: orderNumber ?? this.orderNumber,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      userName: userName ?? this.userName,
    );
  }
}
