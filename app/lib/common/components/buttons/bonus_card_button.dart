import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Кнопка в стиле бонусной карты: белый фон, форма пилюли, иконка и текст акцентным цветом.
/// Используется для «Мой QR» и других действий на бонусной карте.
class BonusCardButton extends StatelessWidget {
  const BonusCardButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.accentColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? AppColors.bonusGradientEnd;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/qr_bonus.svg'),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
