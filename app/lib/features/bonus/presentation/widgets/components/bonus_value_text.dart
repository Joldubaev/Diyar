import 'package:flutter/material.dart';

class BonusValueText extends StatelessWidget {
  final double balance;

  const BonusValueText({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final formattedBalance = balance % 1 == 0 ? balance.toInt().toString() : balance.toStringAsFixed(1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          formattedBalance,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.0,
            letterSpacing: -1.0,
          ),
        ),
        const Text(
          ' Б',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
