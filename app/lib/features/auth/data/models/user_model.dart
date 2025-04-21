import 'package:diyar/features/auth/domain/entities/user_entities.dart';

class UserModel {
  final String phone;
  final String? password;
  final String? userName;
  const UserModel({
    required this.phone,
    this.password,
    this.userName,
  });

  UserModel copyWith({
    String? phone,
    String? password,
    String? userName,
  }) {
    return UserModel(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      userName: userName ?? this.userName,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['phone'] as String,
      password: json['password'] as String?,
      userName: json['userName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      if (password != null) 'password': password,
      if (userName != null) 'userName': userName,
    };
  }

  Map<String, dynamic> toRegister() => {
        "userName": userName,
        "phone": phone,
        "password": password,
      };

  Map<String, dynamic> toLogin() => {
        "phone": phone.toString(),
        "password": password.toString(),
      };

  factory UserModel.fromEntity(UserEntities entity) {
    return UserModel(
      phone: entity.phone,
      password: entity.password,
      userName: entity.userName,
    );
  }

  UserEntities toEntity() {
    return UserEntities(
      phone: phone,
      password: password,
      userName: userName,
    );
  }
}
