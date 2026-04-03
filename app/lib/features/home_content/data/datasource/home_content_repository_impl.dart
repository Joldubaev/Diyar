import 'package:diyar/core/core.dart';
import 'package:diyar/features/home_content/data/datasource/home_content_remote_datasource.dart';
import 'package:diyar/features/home_content/data/model/news_model.dart';
import 'package:diyar/features/home_content/data/model/sale_model.dart';
import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:diyar/features/home_content/domain/repositories/home_content_repository.dart';
import 'package:fpdart/fpdart.dart' show Either;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeContentRemoteDatasource)
class HomeContentRemoteDatasourceImpl implements HomeContentRemoteDatasource {
  final Dio client;

  HomeContentRemoteDatasourceImpl(this.client);

  @override
  Future<List<NewsModel>> fetchNews() async {
    final response = await client.get(ApiConst.getNews);
    if (response.statusCode == 200) {
      final responseData = response.data as Map<String, dynamic>;
      final List<dynamic> newsList = responseData['message'] as List<dynamic>? ?? [];
      return newsList.map((e) => NewsModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw ServerException('Failed to load news', response.statusCode);
    }
  }

  @override
  Future<List<SaleModel>> fetchSales() async {
    final response = await client.get(ApiConst.getSales);
    if (response.statusCode == 200) {
      final responseData = response.data as Map<String, dynamic>;
      final List<dynamic> salesList = responseData['message'] as List<dynamic>? ?? [];
      return salesList.map((e) => SaleModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw ServerException('Failed to load sales', response.statusCode);
    }
  }
}

@LazySingleton(as: HomeContentRepository)
class HomeContentRepositoryImpl with RepositoryErrorHandler implements HomeContentRepository {
  final HomeContentRemoteDatasource remoteDataSource;

  HomeContentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews() {
    return makeRequest(() async {
      final remoteNews = await remoteDataSource.fetchNews();
      return remoteNews.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<SaleEntity>>> getSales() {
    return makeRequest(() async {
      final remoteSales = await remoteDataSource.fetchSales();
      return remoteSales.map((model) => model.toEntity()).toList();
    });
  }
}
