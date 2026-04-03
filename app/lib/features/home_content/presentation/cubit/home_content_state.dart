part of 'home_content_cubit.dart';

sealed class HomeContentState extends Equatable {
  const HomeContentState();

  @override
  List<Object?> get props => [];
}

final class HomeContentInitial extends HomeContentState {
  const HomeContentInitial();
}

/// Единое состояние загрузки главной (все данные через UseCase).
final class HomeContentLoading extends HomeContentState {
  const HomeContentLoading();
}

/// Все данные главной вкладки: новости, акции, популярное, активные заказы, профиль (для бонус-карты).
final class HomeContentLoaded extends HomeContentState {
  final List<NewsEntity> news;
  final List<SaleEntity> sales;
  final List<FoodEntity> popularProducts;
  final List<OrderActiveItemEntity> activeOrders;
  final UserProfileModel? profile;

  const HomeContentLoaded({
    required this.news,
    required this.sales,
    required this.popularProducts,
    required this.activeOrders,
    this.profile,
  });

  @override
  List<Object?> get props => [news, sales, popularProducts, activeOrders, profile];
}

final class GetNewsLoading extends HomeContentState {
  const GetNewsLoading();
}

final class GetNewsLoaded extends HomeContentState {
  final List<NewsEntity> news;

  const GetNewsLoaded({required this.news});

  @override
  List<Object?> get props => [news];
}

final class HomeContentError extends HomeContentState {
  final String message;

  const HomeContentError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class GetSalesLoading extends HomeContentState {
  const GetSalesLoading();
}

final class GetSalesLoaded extends HomeContentState {
  final List<SaleEntity> sales;

  const GetSalesLoaded({required this.sales});

  @override
  List<Object?> get props => [sales];
}


