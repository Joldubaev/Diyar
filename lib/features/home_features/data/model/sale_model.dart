class SaleModel {
  final String? id;
  final String? name;
  final String? description;
  final String? photoLink;
  final int? discount;

  SaleModel({
    this.id,
    this.name,
    this.description,
    this.photoLink,
    this.discount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photoLink': photoLink,
      'discount': discount,
    };
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      photoLink: json['photoLink'],
      discount: json['discount'],
    );
  }
}
