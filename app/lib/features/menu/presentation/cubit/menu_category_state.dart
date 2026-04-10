part of 'menu_category_cubit.dart';

class MenuCategoryState extends Equatable {
  final List<CategoryEntity> categories;
  final int activeIndex;
  final bool isLoading;
  final String? error;

  const MenuCategoryState({
    this.categories = const [],
    this.activeIndex = 0,
    this.isLoading = false,
    this.error,
  });

  MenuCategoryState copyWith({
    List<CategoryEntity>? categories,
    int? activeIndex,
    bool? isLoading,
    String? error,
  }) {
    return MenuCategoryState(
      categories: categories ?? this.categories,
      activeIndex: activeIndex ?? this.activeIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [categories, activeIndex, isLoading, error];
}
