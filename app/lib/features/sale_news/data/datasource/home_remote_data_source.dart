import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';

abstract class HomeRemoteDataSource {
  Future<List<NewsModel>> getNews();
  Future<List<SaleModel>> getSales();
}

class HomeFeaturesRepositoryImpl implements HomeRemoteDataSource {
  final Dio client;

  // In-memory cache
  List<NewsModel>? _newsCache;
  List<SaleModel>? _salesCache;

  HomeFeaturesRepositoryImpl(this.client);

  @override
  Future<List<NewsModel>> getNews() async {
    // Check if data is in the cache
    if (_newsCache != null) {
      return _newsCache!;
    }

    // Fetch data from the network
    final response = await client.get(ApiConst.getNews);

    if (response.statusCode == 200) {
      final List<dynamic> news = response.data;
      _newsCache = news.map((e) => NewsModel.fromJson(e)).toList();
      return _newsCache!;
    } else {
      throw ServerException(
        'Error fetching news data',
        response.statusCode,
      );
    }
  }

  @override
  Future<List<SaleModel>> getSales() async {
    // Check if data is in the cache
    if (_salesCache != null) {
      return _salesCache!;
    }

    // Fetch data from the network
    final response = await client.get(ApiConst.getSales);
    if (response.statusCode == 200) {
      final List<SaleModel> sales = [];
      for (var item in response.data) {
        sales.add(SaleModel.fromJson(item));
      }
      _salesCache = sales;
      return _salesCache!;
    } else {
      throw ServerException(
        'Error fetching sales data',
        response.statusCode,
      );
    }
  }
}
