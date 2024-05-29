class UserModel {
  UserModel({
    this.email,
    this.phone,
    this.name,
    this.password,
  });
  final String? email;
  final String? phone;
  final String? name;
  final String? password;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'userName': name,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      name: map['userName'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
