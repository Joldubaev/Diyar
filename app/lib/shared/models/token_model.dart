import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  const TokenModel({
    required this.role,
    required this.refreshToken,
    required this.accessToken,
  });
  final String role;
  final String refreshToken;
  final String accessToken;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        refreshToken: json["refreshToken"] ?? '',
        accessToken: json["accessToken"] ?? '',
        role: json["role"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "refreshToken": refreshToken,
        "accessToken": accessToken,
        "role": role,
      };

  @override
  List<Object?> get props => [role, refreshToken, accessToken];
}
