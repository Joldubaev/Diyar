/// Parsed server error response body.
class ServerErrorBody {
  ServerErrorBody({this.code, required this.message});

  factory ServerErrorBody.fromJson(Map<String, dynamic> json) {
    return ServerErrorBody(
      code: json['error']?.toString(),
      message: (json['message'] as String?) ?? 'Unknown server error',
    );
  }

  final String? code;
  final String message;

  @override
  String toString() => 'ServerErrorBody(code: $code, message: $message)';
}
