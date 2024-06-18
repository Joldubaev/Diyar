part of 'home_features_cubit.dart';

abstract class HomeFeaturesState {}

final class HomeFeaturesInitial extends HomeFeaturesState {}

final class GetNewsLoading extends HomeFeaturesState {}

final class GetNewsLoaded extends HomeFeaturesState {
  final List<NewsModel> news;

  GetNewsLoaded({required this.news});
}

final class GetNewsError extends HomeFeaturesState {
  final String message;

  GetNewsError({
    required this.message,
  });
}

final class GetSalesLoading extends HomeFeaturesState {}

final class GetSalesLoaded extends HomeFeaturesState {
  final List<SaleModel> sales;

  GetSalesLoaded({required this.sales});
}

final class GetSalesError extends HomeFeaturesState {
  final String message;

  GetSalesError({
    required this.message,
  });
}
