class ResetModel {
  int? code;
  String? phone;
  String? newPassword;

  ResetModel({this.code, this.phone, this.newPassword});

  ResetModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    phone = json['phone'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['phone'] = phone;
    data['newPassword'] = newPassword;
    return data;
  }
}
