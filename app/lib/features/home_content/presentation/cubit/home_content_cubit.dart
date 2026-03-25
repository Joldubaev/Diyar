import 'package:bloc/bloc.dart';
import 'package:diyar/features/active_order/domain/entities/order_active_item_entity.dart';
import 'package:diyar/features/active_order/domain/usecases/get_active_orders_usecase.dart';
import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:diyar/features/home_content/domain/usecases/get_news.dart';
import 'package:diyar/features/home_content/domain/usecases/get_sales.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/domain/usecases/get_popular_products_usecase.dart';
import 'package:diyar/features/profile/data/usecases/get_profile_usecase.dart';
import 'package:diyar/features/profile/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'home_content_state.dart';

@injectable
class HomeContentCubit extends Cubit<HomeContentState> {
  final GetNewsUseCase _getNewsUseCase;
  final GetSalesUseCase _getSalesUseCase;
  final GetPopularProductsUseCase _getPopularProductsUseCase;
  final GetActiveOrdersUseCase _getActiveOrdersUseCase;
  final GetProfileUseCase _getProfileUseCase;

  HomeContentCubit({
    required GetNewsUseCase getNewsUseCase,
    required GetSalesUseCase getSalesUseCase,
    required GetPopularProductsUseCase getPopularProductsUseCase,
    required GetActiveOrdersUseCase getActiveOrdersUseCase,
    required GetProfileUseCase getProfileUseCase,
  })  : _getNewsUseCase = getNewsUseCase,
        _getSalesUseCase = getSalesUseCase,
        _getPopularProductsUseCase = getPopularProductsUseCase,
        _getActiveOrdersUseCase = getActiveOrdersUseCase,
        _getProfileUseCase = getProfileUseCase,
        super(HomeContentInitial());

  /// Загрузка всех данных главной вкладки через UseCase (только этот метод дергать с HomeTabPage).
  Future<void> loadHome({bool loadActiveOrders = true, bool loadProfile = true}) async {
    emit(const HomeContentLoading());

    final newsResult = await _getNewsUseCase();
    final salesResult = await _getSalesUseCase();
    final popularResult = await _getPopularProductsUseCase();
    final ordersResult = loadActiveOrders ? await _getActiveOrdersUseCase() : null;
    final profileResult = loadProfile ? await _getProfileUseCase() : null;

    if (isClosed) return;

    final news = newsResult.fold((_) => <NewsEntity>[], (v) => v);
    final sales = salesResult.fold((_) => <SaleEntity>[], (v) => v);
    final popular = popularResult.fold((_) => <FoodEntity>[], (v) => v);
    final orders = ordersResult?.fold((_) => <OrderActiveItemEntity>[], (v) => v) ?? <OrderActiveItemEntity>[];
    final profile = profileResult?.fold((_) => null, (v) => v);

    emit(HomeContentLoaded(
      news: news,
      sales: sales,
      popularProducts: popular,
      activeOrders: orders,
      profile: profile,
    ));
  }

  Future<void> getNews() async {
    emit(GetNewsLoading());
    final failureOrNews = await _getNewsUseCase();
    failureOrNews.fold(
      (failure) => emit(HomeContentError(message: failure.toString())),
      (news) => emit(GetNewsLoaded(news: news)),
    );
  }

  Future<void> getSales() async {
    emit(GetSalesLoading());
    final failureOrSales = await _getSalesUseCase();
    failureOrSales.fold(
      (failure) => emit(HomeContentError(message: failure.toString())),
      (sales) => emit(GetSalesLoaded(sales: sales)),
    );
  }
}
