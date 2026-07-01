part of 'frequently_ordered_cubit.dart';

class FrequentlyOrderedState extends Equatable {
  final List<FoodEntity> items;
  final bool isLoading;
  final bool hasError;

  const FrequentlyOrderedState({
    this.items = const [],
    this.isLoading = false,
    this.hasError = false,
  });

  FrequentlyOrderedState copyWith({
    List<FoodEntity>? items,
    bool? isLoading,
    bool? hasError,
  }) {
    return FrequentlyOrderedState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, hasError];
}
