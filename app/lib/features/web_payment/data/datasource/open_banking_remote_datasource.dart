import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OpenBankingRemoteDatasource {
  final Dio _dio;

  OpenBankingRemoteDatasource(this._dio);

  /// POST /api/v1/openbanking/create-pay-link
  /// Body: { "amount": number, "orderNumber": string }
  /// Response 200: string — URL платёжной страницы.
  Future<Either<Failure, String>> createPayLink({
    required int amount,
    required String orderNumber,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiConst.createPayLink,
        data: {
          'amount': amount,
          'orderNumber': orderNumber,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final url = response.data;
        if (url is String && url.isNotEmpty) {
          // Валидируем, что это действительно HTTP(S) URL, а не текст ошибки
          final uri = Uri.tryParse(url);
          if (uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')) {
            return Right(url);
          }
          // Бэкенд вернул строку, но не URL (например, текст ошибки) — трактуем как ошибку
          return Left(ServerFailure(url, response.statusCode));
        }
        return const Left(ServerFailure('Неверный формат ответа', 200));
      }
      final msg = response.data is Map
          ? (response.data['message'] ?? response.data['error'])?.toString() ?? 'Ошибка создания ссылки'
          : 'Ошибка создания ссылки';
      return Left(ServerFailure(msg, response.statusCode));
    } on DioException catch (e) {
      if (e.response?.statusCode == 502) {
        final body = e.response?.data;
        final msg =
            body is Map ? body['message']?.toString() ?? body.toString() : body?.toString() ?? 'Ошибка платёжного API';
        return Left(ServerFailure(msg, 502));
      }
      return Left(ServerFailure.fromDio(e));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }
}
