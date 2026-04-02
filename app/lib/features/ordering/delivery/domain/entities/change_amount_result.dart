import 'package:equatable/equatable.dart';

/// Результат выбора суммы сдачи
sealed class ChangeAmountResult extends Equatable {
  const ChangeAmountResult();

  /// Преобразует результат в int? для бизнес-логики
  /// null → сдача не нужна
  /// int → сумма, с которой нужна сдача
  int? toChangeAmount() {
    return switch (this) {
      ExactChange() => null,
      CustomChange(:final amount) => amount,
    };
  }

  /// Получает отображаемый текст для поля
  String getDisplayText(int totalOrderCost) {
    return switch (this) {
      ExactChange() => 'Ровно $totalOrderCost KGS',
      CustomChange(:final amount) => amount.toString(),
    };
  }

  @override
  List<Object?> get props => [];
}

/// Пользователь имеет точную сумму (сдача не нужна)
final class ExactChange extends ChangeAmountResult {
  const ExactChange();
}

/// Пользователь указал произвольную сумму для сдачи
final class CustomChange extends ChangeAmountResult {
  final int amount;

  const CustomChange(this.amount);

  @override
  List<Object?> get props => [amount];
}
