import 'package:diyar/features/home_content/data/model/news_model.dart'; // Используем новые пути
import 'package:diyar/features/home_content/data/model/sale_model.dart';

// Переименовываем интерфейс
abstract class HomeContentRemoteDatasource {
  Future<List<NewsModel>> fetchNews(); 
  Future<List<SaleModel>> fetchSales();
}

