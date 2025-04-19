class GeneralRes<T> {
  const GeneralRes({
    required this.code,
    required this.message,
    this.data,
  });

  factory GeneralRes.fromJson(
    Map<String, dynamic> map, {
    T Function(Map<String, dynamic>)? fromJson,
  }) {
    return GeneralRes(
      code: map['code'] as int,
      message: map['message'] as String,
      data: fromJson != null && map['data'] != null ? fromJson(map['data'] as Map<String, dynamic>) : null,
    );
  }

  final int code;
  final String message;
  final T? data;

  Map<String, dynamic> toJson({
    Map<String, dynamic> Function(T)? toJson,
  }) {
    return <String, dynamic>{
      'code': code,
      'message': message,
      if (data != null && toJson != null) 'data': toJson(data!),
    };
  }

  bool get isSuccess => code >= 200 && code < 300;
  bool get isError => !isSuccess;
}
