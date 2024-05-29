class CurierOrderModel {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userPhone;
  final int? orderNumber;
  final int? dishesCount;
  final List<Food>? foods;
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

  CurierOrderModel({
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

  factory CurierOrderModel.fromJson(Map<String, dynamic> map) {
    return CurierOrderModel(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      userPhone: map['userPhone'],
      orderNumber: map['orderNumber'],
      dishesCount: map['dishesCount'],
      foods: map['foods'] != null ? List<Food>.from(map['foods']?.map((x) => Food.fromJson(x))) : null,
      address: map['address'],
      houseNumber: map['houseNumber'],
      kvOffice: map['kvOffice'],
      intercom: map['intercom'],
      floor: map['floor'],
      entrance: map['entrance'],
      comment: map['comment'],
      paymentMethod: map['paymentMethod'],
      price: map['price'],
      timeRequest: map['timeRequest'],
      courierId: map['courierId'],
      status: map['status'],
      deliveryPrice: map['deliveryPrice'],
      sdacha: map['sdacha'],
    );
  }
}

class Food {
  final int? quantity;
  final String? name;
  final int? price;

  Food({
    this.quantity,
    this.name,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'name': name,
      'price': price,
    };
  }

  factory Food.fromJson(Map<String, dynamic> map) {
    return Food(
      quantity: map['quantity']?.toInt(),
      name: map['name'],
      price: map['price']?.toInt(),
    );
  }
}
