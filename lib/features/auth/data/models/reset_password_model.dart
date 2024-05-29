class ResetModel {
  int? code;
  String? email;
  String? newPassword;

  ResetModel({this.code, this.email, this.newPassword});

  ResetModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    email = json['email'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['email'] = email;
    data['newPassword'] = newPassword;
    return data;
  }
}
