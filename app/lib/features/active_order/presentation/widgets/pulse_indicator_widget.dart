import 'package:flutter/material.dart';

class PulseIndicator extends StatefulWidget {
  const PulseIndicator({super.key});

  @override
  State<PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<PulseIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Анимация будет идти бесконечно
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Внешний пульсирующий круг
            Container(
              width: 18 * _controller.value + 10,
              height: 18 * _controller.value + 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF27AE60).withValues(alpha: 1 - _controller.value),
              ),
            ),
            // Основной статичный круг
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF27AE60),
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      },
    );
  }
}
