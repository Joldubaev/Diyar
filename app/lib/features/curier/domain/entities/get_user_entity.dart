import 'package:equatable/equatable.dart';

class GetUserEntity extends Equatable {
  final String? id;
  final String? userName;
  final String? email;
  final String? phone;
  final String? role;
  final int? discount;

  const GetUserEntity({
    this.id,
    this.userName,
    this.email,
    this.phone,
    this.role,
    this.discount,
  });

  @override
  List<Object?> get props => [
        id,
        userName,
        email,
        phone,
        role,
        discount,
      ];
}
