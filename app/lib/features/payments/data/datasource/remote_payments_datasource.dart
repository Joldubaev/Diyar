import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/payments/data/models/model.dart';
import 'package:diyar/features/payments/presentation/presentation.dart';

abstract class RemotePaymentsDatasource {
  Future<Either<Failure, String>> checkPaymentMega(PaymentsModel model);
  Future<Either<Failure, String>> megaInitiate(PaymentsModel model);
  Future<Either<Failure, String>> megaStatus(String orderNumber);
  Future<Either<Failure, MbankModel>> mbankInitiate(PaymentsModel model);
  Future<Either<Failure, MbankModel>> mbankConfirm(PaymentsModel model);
  Future<Either<Failure, String>> mbankStatus(String orderNumber);

  Future<Either<Failure, QrPaymentStatusModel>> qrCheckStatus(String transactionId, String orderNumber);
  Future<Either<Failure, QrCodeModel>> qrGenerate(int amount);
}

class RemotePaymentsDatasourceImpl implements RemotePaymentsDatasource {
  final Dio dio;

  RemotePaymentsDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, MbankModel>> mbankInitiate(PaymentsModel model) async {
    try {
      final response = await dio.post(
        ApiConst.mbankInitiate,
        options: Options(
          headers: BaseHelper.getHeaders(isAuth: true),
        ),
        data: {
          "orderNumber": model.orderNumber,
          "phone": model.user,
          "amount": model.amount,
        },
      );
      final code = response.data['code'].toString();
      final status = PaymentStatusMapper.fromCode(code);
      final message = PaymentStatusMapper.message(status, response.data['message']);
      if (status == PaymentStatusEnum.success) {
        return Right(MbankModel.fromJson(response.data['data']));
      } else {
        return Left(ServerFailure(message, response.statusCode));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка сети', e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }

  @override
  Future<Either<Failure, MbankModel>> mbankConfirm(PaymentsModel model) async {
    try {
      final response = await dio.post(
        ApiConst.mbankConfirm,
        options: Options(
          headers: BaseHelper.getHeaders(isAuth: true),
        ),
        data: {
          "orderNumber": model.orderNumber,
          "otp": model.otp,
        },
      );
      final code = response.data['code'].toString();
      final status = PaymentStatusMapper.fromCode(code);
      final message = PaymentStatusMapper.message(status, response.data['message']);
      if (status == PaymentStatusEnum.success) {
        return Right(MbankModel.fromJson(response.data['data']));
      } else {
        return Left(ServerFailure(message, response.statusCode));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка сети', e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }

  @override
  Future<Either<Failure, String>> mbankStatus(String orderNumber) async {
    try {
      final response = await dio.get(
        ApiConst.mbankStatus,
        options: Options(
          headers: BaseHelper.getHeaders(isAuth: true),
        ),
        queryParameters: {"orderNumber": orderNumber},
      );
      final code = response.data['code'].toString();
      final status = PaymentStatusMapper.fromCode(code);
      final message = PaymentStatusMapper.message(status, response.data['message']);
      if (status == PaymentStatusEnum.success) {
        return Right(response.data['data']?.toString() ?? '');
      } else {
        return Left(ServerFailure(message, response.statusCode));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка сети', e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }

  @override
  Future<Either<Failure, String>> checkPaymentMega(PaymentsModel model) async {
    try {
      final response = await dio.post(
        ApiConst.checkPaymentMega,
        options: Options(
          headers: BaseHelper.getHeaders(isAuth: true),
        ),
        data: {
          "orderNumber": model.orderNumber,
          "user": model.user,
          "amount": model.amount,
        },
      );
      final code = response.data['code'].toString();
      final status = PaymentStatusMapper.fromCode(code);
      final message = PaymentStatusMapper.message(status, response.data['message']);
      if (status == PaymentStatusEnum.success) {
        return Right(response.data['orderNumber']);
      } else {
        return Left(ServerFailure(message, response.statusCode));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка сети', e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }

  @override
  Future<Either<Failure, String>> megaInitiate(PaymentsModel model) async {
    try {
      final response = await dio.post(
        ApiConst.megaInitiate,
        options: Options(
          headers: BaseHelper.getHeaders(isAuth: true),
        ),
        data: {
          "orderNumber": model.orderNumber,
          "user": model.user,
          "amount": model.amount,
          "pinCode": model.pinCode,
        },
      );
      final code = response.data['code'].toString();
      final status = PaymentStatusMapper.fromCode(code);
      final message = PaymentStatusMapper.message(status, response.data['message']);
      if (status == PaymentStatusEnum.success) {
        return Right(response.data['data']['transactionId'].toString());
      } else {
        return Left(ServerFailure(message, response.statusCode));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка сети', e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }

  @override
  Future<Either<Failure, String>> megaStatus(String orderNumber) async {
    try {
      final response = await dio.get(
        ApiConst.megaStatus,
        options: Options(
          headers: BaseHelper.getHeaders(isAuth: true),
        ),
        queryParameters: {"orderNumber": orderNumber},
      );
      final code = response.data['code'].toString();
      final status = PaymentStatusMapper.fromCode(code);
      final message = PaymentStatusMapper.message(status, response.data['message']);
      if (status == PaymentStatusEnum.success) {
        return Right(response.data['data']?.toString() ?? '');
      } else {
        return Left(ServerFailure(message, response.statusCode));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка сети', e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }

  @override
  Future<Either<Failure, QrCodeModel>> qrGenerate(int amount) async {
    try {
      final response = await dio.post(ApiConst.generateQRCode,
          options: Options(
            headers: BaseHelper.getHeaders(isAuth: true),
          ),
          queryParameters: {'sum': amount});
      if (response.data['code'].toString() == '100') {
        return Right(QrCodeModel.fromJson(response.data['data']));
      } else {
        return Left(ServerFailure(response.statusMessage ?? 'Ошибка', response.statusCode));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка сети', e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }

  @override
  Future<Either<Failure, QrPaymentStatusModel>> qrCheckStatus(String transactionId, String orderNumber) async {
    try {
      final response = await dio.get(
        ApiConst.checkQRCodeStatus,
        options: Options(
          headers: BaseHelper.getHeaders(isAuth: true),
        ),
        queryParameters: {
          "transactionId": transactionId,
          "orderNumber": orderNumber,
        },
      );
      final code = response.data['code'].toString();
      final message = response.data['message'] ?? '';

      PaymentStatusEnum status;
      if (code == '100') {
        final dataStatus = response.data['data']?.toString();
        if (dataStatus == 'SUCCESSFUL') {
          status = PaymentStatusEnum.success;
        } else {
          status = PaymentStatusEnum.pending;
        }
      } else {
        status = PaymentStatusMapper.fromCode(code);
      }

      return Right(QrPaymentStatusModel(code: code, message: message, status: status));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка сети', e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }
}
