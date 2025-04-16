class GetUserModel {
  final String? id;
  final String? userName;
  final String? email;
  final String? phone;
  final String? role;

  GetUserModel({
    this.id,
    this.userName,
    this.email,
    this.phone,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }

  factory GetUserModel.fromJson(Map<String, dynamic> map) {
    return GetUserModel(
      id: map['id'],
      userName: map['userName'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
    );
  }
}
