class DistricModel {
  final String? name;
  final int? price;

  DistricModel({
    this.name,
    this.price,
  });

  DistricModel copyWith({
    String? name,
    int? price,
  }) =>
      DistricModel(
        name: name ?? this.name,
        price: price ?? this.price,
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }

  factory DistricModel.fromJson(Map<String, dynamic> map) {
    return DistricModel(
      name: map['name'] as String?,
      price: map['price'] is int
          ? map['price'] as int
          : int.tryParse(map['price']?.toString() ?? '0') ?? 0,
    );
  }
}
