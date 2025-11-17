import 'package:diyar/core/core.dart';
// import 'package:diyar/core/error/failure.dart'; // Временно
import 'package:diyar/features/home_content/data/datasource/home_content_remote_datasource.dart';
import 'package:diyar/features/home_content/data/model/news_model.dart';
import 'package:diyar/features/home_content/data/model/sale_model.dart';
import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:diyar/features/home_content/domain/repositories/home_content_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart'; // Нужен Dio для реализации datasource здесь (или в отдельном файле)
import 'package:injectable/injectable.dart';

// --- РЕАЛИЗАЦИЯ DATASOURCE (временно здесь, лучше в отдельном файле) ---
// Используем код из старого home_remote_data_source.dart
@LazySingleton(as: HomeContentRemoteDatasource)
class HomeContentRemoteDatasourceImpl implements HomeContentRemoteDatasource {
  final Dio client;

  HomeContentRemoteDatasourceImpl(this.client);

  @override
  Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await client.get(ApiConst.getNews);
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final List<dynamic> newsList = responseData['message'] as List<dynamic>? ?? [];
        return newsList.map((e) => NewsModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw ServerException('Failed to load news', response.statusCode);
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Dio error', e.response?.statusCode);
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<List<SaleModel>> fetchSales() async {
    try {
      final response = await client.get(ApiConst.getSales);
      if (response.statusCode == 200) {
        // ПАРСИНГ ОТВЕТА ДЛЯ SALES (нужно адаптировать под реальный ответ)
        // Пример:
        final responseData = response.data as Map<String, dynamic>;
        final List<dynamic> salesList = responseData['message'] as List<dynamic>? ?? [];
        return salesList.map((e) => SaleModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw ServerException('Failed to load sales', response.statusCode);
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Dio error', e.response?.statusCode);
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}
// --- КОНЕЦ РЕАЛИЗАЦИИ DATASOURCE ---

// --- РЕАЛИЗАЦИЯ РЕПОЗИТОРИЯ ---
@LazySingleton(as: HomeContentRepository)
class HomeContentRepositoryImpl implements HomeContentRepository {
  final HomeContentRemoteDatasource remoteDataSource;
  // final NetworkInfo networkInfo; // Если используете проверку сети

  HomeContentRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<dynamic, List<NewsEntity>>> getNews() async {
    // if (await networkInfo.isConnected) { // Пример проверки сети
    try {
      final remoteNews = await remoteDataSource.fetchNews();
      // Преобразуем Model в Entity
      return Right(remoteNews.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Возвращаем Failure (пока dynamic)
      return Left(e); // Или ваш класс Failure(e.message)
    }
    // } else {
    //   return Left(NetworkFailure()); // Пример ошибки сети
    // }
  }

  @override
  Future<Either<dynamic, List<SaleEntity>>> getSales() async {
    // if (await networkInfo.isConnected) {
    try {
      final remoteSales = await remoteDataSource.fetchSales();
      // Преобразуем Model в Entity
      return Right(remoteSales.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(e);
    }
    // } else {
    //   return Left(NetworkFailure());
    // }
  }
}
// --- КОНЕЦ РЕАЛИЗАЦИИ РЕПОЗИТОРИЯ ---
