import 'package:injectable/injectable.dart';

/// Результат валидации бонусов
enum BonusValidationResult {
  valid,
  exceedsBalance,
  exceedsOrderTotal,
  invalidAmount,
}

/// Use case для валидации суммы бонусов
@injectable
class ValidateBonusUseCase {
  /// Валидирует сумму бонусов
  /// 
  /// Возвращает [BonusValidationResult] с результатом проверки
  BonusValidationResult validate({
    required double? amount,
    required double userBalance,
    required int orderTotal,
  }) {
    // Если бонусы не указаны или равны 0 - валидно
    if (amount == null || amount == 0) {
      return BonusValidationResult.valid;
    }

    // Проверка на отрицательное значение
    if (amount < 0) {
      return BonusValidationResult.invalidAmount;
    }

    // Проверка: бонусы не должны превышать баланс пользователя
    if (amount > userBalance) {
      return BonusValidationResult.exceedsBalance;
    }

    // Проверка: бонусы не должны превышать полную стоимость заказа
    if (amount > orderTotal) {
      return BonusValidationResult.exceedsOrderTotal;
    }

    return BonusValidationResult.valid;
  }

  /// Проверяет, является ли результат валидации успешным
  bool isValid(BonusValidationResult result) {
    return result == BonusValidationResult.valid;
  }

  /// Возвращает сообщение об ошибке для результата валидации
  String getErrorMessage(BonusValidationResult result, {
    required double userBalance,
    required int orderTotal,
  }) {
    switch (result) {
      case BonusValidationResult.exceedsBalance:
        return 'Сумма бонусов превышает баланс. Доступно: ${userBalance.toStringAsFixed(0)} сом';
      case BonusValidationResult.exceedsOrderTotal:
        return 'Сумма бонусов не может превышать стоимость заказа ($orderTotal сом)';
      case BonusValidationResult.invalidAmount:
        return 'Некорректная сумма бонусов';
      case BonusValidationResult.valid:
        return '';
    }
  }
}
