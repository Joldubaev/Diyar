part of 'search_cubit.dart';

class MenuSearchState extends Equatable {
  final List<FoodEntity> results;
  final bool isLoading;
  final String? error;

  const MenuSearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isEmpty => results.isEmpty && !isLoading && error == null;

  MenuSearchState copyWith({
    List<FoodEntity>? results,
    bool? isLoading,
    String? error,
  }) {
    return MenuSearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [results, isLoading, error];
}
