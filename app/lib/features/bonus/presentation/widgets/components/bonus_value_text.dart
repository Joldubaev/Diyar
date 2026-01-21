import 'package:flutter/material.dart';

/// Переиспользуемый компонент для отображения баланса бонусов
class BonusValueText extends StatelessWidget {
  final double balance; // Изменено с int на double для поддержки десятичных значений (например, 11.5)

  const BonusValueText({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    // Форматируем баланс: если есть десятичная часть, показываем её, иначе показываем как целое число
    final formattedBalance = balance % 1 == 0 
        ? balance.toInt().toString() 
        : balance.toStringAsFixed(1);
    
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: formattedBalance,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.0,
              letterSpacing: -0.5,
            ),
          ),
          TextSpan(
            text: ' баллов',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
