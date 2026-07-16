part of 'garnish_cubit.dart';

class GarnishState extends Equatable {
  final List<FoodEntity> items;
  final bool isLoading;
  final bool hasError;

  /// `null` — ничего не выбрано, `0` — «Без гарнира», `index + 1` — гарнир из [items].
  final int? selectedIndex;

  const GarnishState({
    this.items = const [],
    this.isLoading = false,
    this.hasError = false,
    this.selectedIndex,
  });

  GarnishState copyWith({
    List<FoodEntity>? items,
    bool? isLoading,
    bool? hasError,
    int? selectedIndex,
  }) {
    return GarnishState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, hasError, selectedIndex];
}
