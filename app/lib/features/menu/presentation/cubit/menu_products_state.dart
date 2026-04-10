part of 'menu_products_cubit.dart';

class MenuProductsState extends Equatable {
  final List<CategoryFoodEntity> foods;
  final bool isLoading;
  final String? error;

  const MenuProductsState({
    this.foods = const [],
    this.isLoading = false,
    this.error,
  });

  MenuProductsState copyWith({
    List<CategoryFoodEntity>? foods,
    bool? isLoading,
    String? error,
  }) {
    return MenuProductsState(
      foods: foods ?? this.foods,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [foods, isLoading, error];
}
