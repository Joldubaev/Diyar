part of 'menu_products_cubit.dart';

/// Одна секция меню — категория со своими блюдами.
/// Лента меню строится как упорядоченный список таких секций.
class CategorySection extends Equatable {
  final String categoryName;
  final List<FoodEntity> foods;
  final bool isLoading;
  final String? error;

  const CategorySection({
    required this.categoryName,
    this.foods = const [],
    this.isLoading = false,
    this.error,
  });

  CategorySection copyWith({
    List<FoodEntity>? foods,
    bool? isLoading,
    String? error,
  }) {
    return CategorySection(
      categoryName: categoryName,
      foods: foods ?? this.foods,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [categoryName, foods, isLoading, error];
}

class MenuProductsState extends Equatable {
  final List<CategorySection> sections;

  /// Идёт начальная инициализация (категории ещё не пришли — секций нет).
  final bool isInitialLoading;
  final String? error;

  const MenuProductsState({
    this.sections = const [],
    this.isInitialLoading = false,
    this.error,
  });

  MenuProductsState copyWith({
    List<CategorySection>? sections,
    bool? isInitialLoading,
    String? error,
  }) {
    return MenuProductsState(
      sections: sections ?? this.sections,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [sections, isInitialLoading, error];
}
