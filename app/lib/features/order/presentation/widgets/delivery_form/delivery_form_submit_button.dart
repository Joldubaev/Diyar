import 'package:flutter/material.dart';

/// Кнопка подтверждения формы доставки
class DeliveryFormSubmitButton extends StatelessWidget {
  final ThemeData theme;
  final int totalOrderCost;
  final VoidCallback onConfirm;

  const DeliveryFormSubmitButton({
    super.key,
    required this.theme,
    required this.totalOrderCost,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.primary,
      child: ListTile(
        title: Text(
          'Сумма заказа $totalOrderCost сом',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onTertiaryFixed,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: theme.colorScheme.onTertiaryFixed,
        ),
        onTap: onConfirm,
      ),
    );
  }
}

