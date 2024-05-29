import 'package:diyar/features/home_features/data/datasource/home_remote_data_source.dart';
import 'package:diyar/features/home_features/data/model/news_model.dart';
import 'package:diyar/features/home_features/data/model/sale_model.dart';

abstract class HomeRepository {
  Future<List<NewsModel>> getNews();
  Future<List<SaleModel>> getSales();
}

class HomeFeaturesRepoImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeFeaturesRepoImpl(this.remoteDataSource);

  @override
  Future<List<NewsModel>> getNews() async {
    return remoteDataSource.getNews();
  }

  @override
  Future<List<SaleModel>> getSales() async {
    return remoteDataSource.getSales();
  }
}
