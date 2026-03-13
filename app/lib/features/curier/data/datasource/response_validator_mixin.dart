import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';

mixin ResponseValidatorMixin {
  void validateResponse(Response res) {
    final code = res.data['code'];
    if (![200, 201].contains(code)) {
      throw ServerException(
        res.data['message']?.toString() ?? 'Error from server',
        code is int ? code : null,
      );
    }
  }
}
