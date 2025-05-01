part of 'home_content_cubit.dart';

abstract class HomeContentState {}

final class HomeContentInitial extends HomeContentState {}

final class GetNewsLoading extends HomeContentState {}

final class GetNewsLoaded extends HomeContentState {
  final List<NewsEntity> news;

  GetNewsLoaded({required this.news});
}

final class HomeContentError extends HomeContentState {
  final String message;

  HomeContentError({
    required this.message,
  });
}

final class GetSalesLoading extends HomeContentState {}

final class GetSalesLoaded extends HomeContentState {
  final List<SaleEntity> sales;

  GetSalesLoaded({required this.sales});
}


