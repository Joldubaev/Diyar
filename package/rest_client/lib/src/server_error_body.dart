class ServerErrorBody {
  ServerErrorBody({this.code, required this.message});

  factory ServerErrorBody.fromJson(Map<String, dynamic> json) {
    return ServerErrorBody(
      code: json["error"]?.toString(), // может быть null
      message: json["message"] ?? "Unknown server error",
    );
  }

  final String? code;
  final String message;

  @override
  String toString() => 'ServerErrorBody(code: $code, message: $message)';
}
