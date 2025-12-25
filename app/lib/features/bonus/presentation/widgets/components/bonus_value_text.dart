import 'package:flutter/material.dart';

/// Переиспользуемый компонент для отображения баланса бонусов
class BonusValueText extends StatelessWidget {
  final int balance;

  const BonusValueText({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$balance',
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
