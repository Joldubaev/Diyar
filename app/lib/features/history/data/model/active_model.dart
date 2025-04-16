import '../../../menu/menu.dart';

class ActiveOrderModel {
  final OrderActiveItemModel? order;
  final String? courierName;
  final String? courierNumber;

  ActiveOrderModel({this.order, this.courierName, this.courierNumber});

  Map<String, dynamic> toJson() {
    return {
      'order': order?.toJson(),
      'courierName': courierName,
      'courierNumber': courierNumber,
    };
  }

  factory ActiveOrderModel.fromJson(Map<String, dynamic> map) {
    return ActiveOrderModel(
      order: map['order'] != null
          ? OrderActiveItemModel.fromJson(map['order'])
          : null,
      courierName: map['courierName'],
      courierNumber: map['courierNumber'],
    );
  }
}

class OrderActiveItemModel {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userPhone;
  final int? orderNumber;
  final int? dishesCount;
  final List<FoodModel>? foods;
  final String? address;
  final String? houseNumber;
  final String? kvOffice;
  final String? intercom;
  final String? floor;
  final String? entrance;
  final String? comment;
  final String? paymentMethod;
  final int? price;
  final String? timeRequest;
  final String? courierId;
  final String? status;
  final int? deliveryPrice;
  final int? sdacha;

  OrderActiveItemModel({
    this.id,
    this.userId,
    this.userName,
    this.userPhone,
    this.orderNumber,
    this.dishesCount,
    this.foods,
    this.address,
    this.houseNumber,
    this.kvOffice,
    this.intercom,
    this.floor,
    this.entrance,
    this.comment,
    this.paymentMethod,
    this.price,
    this.timeRequest,
    this.courierId,
    this.status,
    this.deliveryPrice,
    this.sdacha,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'orderNumber': orderNumber,
      'dishesCount': dishesCount,
      'foods': foods?.map((x) => x.toJson()).toList(),
      'address': address,
      'houseNumber': houseNumber,
      'kvOffice': kvOffice,
      'intercom': intercom,
      'floor': floor,
      'entrance': entrance,
      'comment': comment,
      'paymentMethod': paymentMethod,
      'price': price,
      'timeRequest': timeRequest,
      'courierId': courierId,
      'status': status,
      'deliveryPrice': deliveryPrice,
      'sdacha': sdacha,
    };
  }

  factory OrderActiveItemModel.fromJson(Map<String, dynamic> map) {
    return OrderActiveItemModel(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      userPhone: map['userPhone'],
      orderNumber: map['orderNumber']?.toInt(),
      dishesCount: map['dishesCount']?.toInt(),
      foods: map['foods'] != null
          ? List<FoodModel>.from(
              map['foods']?.map((x) => FoodModel.fromJson(x)))
          : null,
      address: map['address'],
      houseNumber: map['houseNumber'],
      kvOffice: map['kvOffice'],
      intercom: map['intercom'],
      floor: map['floor'],
      entrance: map['entrance'],
      comment: map['comment'],
      paymentMethod: map['paymentMethod'],
      price: map['price']?.toInt(),
      timeRequest: map['timeRequest'],
      courierId: map['courierId'],
      status: map['status'],
      deliveryPrice: map['deliveryPrice']?.toInt(),
      sdacha: map['sdacha']?.toInt(),
    );
  }
}
