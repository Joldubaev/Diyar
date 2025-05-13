import 'package:equatable/equatable.dart';

class GetUserEntity extends Equatable {
  final String? id;
  final String? userName;
  final String? email;
  final String? phone;
  final String? role;

  const GetUserEntity({
    this.id,
    this.userName,
    this.email,
    this.phone,
    this.role,
  });

  @override
  List<Object?> get props => [
        id,
        userName,
        email,
        phone,
        role,
      ];
}
