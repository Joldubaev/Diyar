class OrderStatusModel {
  final int orderNumber;
  final String status;

  OrderStatusModel({
    required this.orderNumber,
    required this.status,
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      orderNumber: json['orderNumber'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'status': status,
    };
  }
}
