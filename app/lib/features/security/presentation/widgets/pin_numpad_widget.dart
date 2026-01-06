import 'package:flutter/material.dart';

/// Виджет цифровой клавиатуры для ввода PIN-кода
class PinNumpadWidget extends StatelessWidget {
  /// Callback при нажатии на цифровую кнопку
  final ValueChanged<int> onNumberPressed;

  /// Флаг, указывающий, должны ли кнопки быть неактивными
  final bool disabled;

  const PinNumpadWidget({
    super.key,
    required this.onNumberPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ряды кнопок 1-9
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (index) => _buildNumberButton(1 + 3 * i + index, disabled, context),
              ).toList(),
            ),
          ),
        // Нижний ряд будет добавлен отдельно в использующих виджетах,
        // так как он отличается (0, backspace, exit/biometric)
      ],
    );
  }

  // Приватный метод для создания кнопки с цифрой
  Widget _buildNumberButton(int number, bool disabled, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: disabled ? null : () => onNumberPressed(number),
        style: TextButton.styleFrom(
          foregroundColor: Colors.black, 
          shape: const CircleBorder(), 
          padding: const EdgeInsets.all(16), 
          minimumSize: const Size(64, 64), // Минимальный размер кнопки
        ),
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
