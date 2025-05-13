import 'package:diyar/features/curier/domain/domain.dart';

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

  factory GetUserModel.fromEntity(GetUserEntity entity) {
    return GetUserModel(
      id: entity.id,
      userName: entity.userName,
      email: entity.email,
      phone: entity.phone,
      role: entity.role,
    );
  }
  GetUserEntity toEntity() {
    return GetUserEntity(
      id: id,
      userName: userName,
      email: email,
      phone: phone,
      role: role,
    );
  }
}
