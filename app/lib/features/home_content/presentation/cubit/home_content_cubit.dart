import 'package:bloc/bloc.dart';
import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:diyar/features/home_content/domain/usecases/get_news.dart';
import 'package:diyar/features/home_content/domain/usecases/get_sales.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/user/profile/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'home_content_state.dart';

@injectable
class HomeContentCubit extends Cubit<HomeContentState> {
  final GetNewsUseCase _getNewsUseCase;
  final GetSalesUseCase _getSalesUseCase;
  final MenuRepository _menuRepository;
  final ActiveOrderRepository _activeOrderRepository;
  final ProfileRepository _profileRepository;

  HomeContentCubit({
    required GetNewsUseCase getNewsUseCase,
    required GetSalesUseCase getSalesUseCase,
    required MenuRepository menuRepository,
    required ActiveOrderRepository activeOrderRepository,
    required ProfileRepository profileRepository,
  })  : _getNewsUseCase = getNewsUseCase,
        _getSalesUseCase = getSalesUseCase,
        _menuRepository = menuRepository,
        _activeOrderRepository = activeOrderRepository,
        _profileRepository = profileRepository,
        super(HomeContentInitial());

  /// Load all home tab data in parallel using Future.wait for faster startup.
  Future<void> loadHome({
    bool loadActiveOrders = true,
    bool loadProfile = true,
  }) async {
    emit(const HomeContentLoading());

    final futures = await (
      _getNewsUseCase(),
      _getSalesUseCase(),
      _menuRepository.getPopularFoods(),
      loadActiveOrders
          ? _activeOrderRepository.getActiveOrders()
          : Future.value(null),
      loadProfile ? _profileRepository.getUser() : Future.value(null),
    ).wait;

    if (isClosed) return;

    final news = futures.$1.fold((_) => <NewsEntity>[], (v) => v);
    final sales = futures.$2.fold((_) => <SaleEntity>[], (v) => v);
    final popular = futures.$3.fold((_) => <FoodEntity>[], (v) => v);
    final orders = futures.$4?.fold(
          (_) => <OrderActiveItemEntity>[],
          (v) => v,
        ) ??
        <OrderActiveItemEntity>[];
    final profile = futures.$5?.fold((_) => null, (v) => v);

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
