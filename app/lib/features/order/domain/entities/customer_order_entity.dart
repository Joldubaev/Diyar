import 'package:diyar/features/menu/menu.dart';

class CustomerOrderEntity {
  final String ?id;
  final List<FoodEntity>? foods;
  final String? address;
  final String? status;

  CustomerOrderEntity({
     this.id,
     this.foods,
     this.address,
     this.status,
  });
}
