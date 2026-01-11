import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/data/models/model.dart';
import 'package:injectable/injectable.dart';

abstract class BonusRemoteDataSource {
  Future<QrGenerateModel> generateQr();
  Future<BonusTransactionResponseModel> getBonusTransactions({
    int page = 1,
    int pageSize = 50,
    String? userId,
    String? transactionType,
    String? dateFrom,
    String? dateTo,
  });
}

@LazySingleton(as: BonusRemoteDataSource)
class BonusRemoteDataSourceImpl implements BonusRemoteDataSource {
  final Dio _dio;

  BonusRemoteDataSourceImpl(this._dio);

  @override
  Future<QrGenerateModel> generateQr() async {
    final response = await _dio.post(ApiConst.generateBonusQr);
    final data = response.data;
    if (data is! Map<String, dynamic> || !data.containsKey('message')) {
      throw const FormatException('Invalid response structure: missing "message" field');
    }
    final message = data['message'];
    if (message is! Map<String, dynamic>) {
      throw const FormatException('Field "message" must be a Map');
    }
    return QrGenerateModel.fromJson(message);
  }

  @override
  Future<BonusTransactionResponseModel> getBonusTransactions({
    int page = 1,
    int pageSize = 50,
    String? userId,
    String? transactionType,
    String? dateFrom,
    String? dateTo,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (userId != null && userId.isNotEmpty) {
      queryParams['userId'] = userId;
    }
    if (transactionType != null && transactionType.isNotEmpty) {
      queryParams['transactionType'] = transactionType;
    }
    if (dateFrom != null && dateFrom.isNotEmpty) {
      queryParams['dateFrom'] = dateFrom;
    }
    if (dateTo != null && dateTo.isNotEmpty) {
      queryParams['dateTo'] = dateTo;
    }

    final response = await _dio.get(
      ApiConst.getBonusTransactions,
      queryParameters: queryParams,
    );

    final data = response.data;
    if (data is! Map<String, dynamic> || !data.containsKey('message')) {
      throw const FormatException('Invalid response structure: missing "message" field');
    }
    final message = data['message'];
    if (message is! Map<String, dynamic>) {
      throw const FormatException('Field "message" must be a Map');
    }

    final transactions = (message['transactions'] as List<dynamic>?)
            ?.map((x) => BonusTransactionModel.fromJson(x as Map<String, dynamic>))
            .toList() ??
        [];
    final totalItems = message['totalItems'] as int? ?? 0;
    final totalPages = message['totalPages'] as int? ?? 1;

    return BonusTransactionResponseModel(
      transactions: transactions,
      totalItems: totalItems,
      totalPages: totalPages,
    );
  }
}
