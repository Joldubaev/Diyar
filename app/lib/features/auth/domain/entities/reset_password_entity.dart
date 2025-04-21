class ResetPasswordEntity {
  final String? phone;
  final String? newPassword;
  final int? code;

  ResetPasswordEntity({
    this.phone,
    this.newPassword,
    this.code,
  });
}
