import 'package:dio/dio.dart';
import 'package:diyar/core/error/exception.dart';
import 'package:diyar/features/home_features/data/model/news_model.dart';
import 'package:diyar/features/home_features/data/model/sale_model.dart';
import 'package:diyar/shared/shared.dart';

abstract class HomeRemoteDataSource {
  Future<List<NewsModel>> getNews();
  Future<List<SaleModel>> getSales();
}

class HomeFeaturesRepositoryImpl implements HomeRemoteDataSource {
  final Dio client;

  HomeFeaturesRepositoryImpl(this.client);

  @override
  Future<List<NewsModel>> getNews() async {
    final response = await client.get(ApiConst.getNews);

    if (response.statusCode == 200) {
      final List<dynamic> news = response.data;
      return news.map((e) => NewsModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SaleModel>> getSales() async {
    final response = await client.get(ApiConst.getSales);
    if (response.statusCode == 200) {
      final List<SaleModel> sales = [];
      for (var item in response.data) {
        sales.add(SaleModel.fromJson(item));
      }
      return sales;
    } else {
      throw ServerException();
    }
  }
}
