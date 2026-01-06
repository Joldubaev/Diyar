import 'package:flutter/material.dart';

/// Содержимое диалога выбора суммы сдачи
class ChangeAmountDialogContent extends StatelessWidget {
  final ThemeData theme;
  final int totalOrderCost;
  final TextEditingController amountController;
  final bool hasExactAmount;
  final ValueChanged<bool> onExactAmountChanged;

  const ChangeAmountDialogContent({
    super.key,
    required this.theme,
    required this.totalOrderCost,
    required this.amountController,
    required this.hasExactAmount,
    required this.onExactAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(),
        const SizedBox(height: 20),
        _buildTitle(),
        const SizedBox(height: 8),
        _buildSubtitle(colors),
        const SizedBox(height: 24),
        _buildAmountField(colors),
        const SizedBox(height: 16),
        _buildExactAmountCheckbox(colors),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.attach_money,
        size: 32,
        color: Colors.green.shade700,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'С какой суммы понадобится сдача?',
      textAlign: TextAlign.center,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSubtitle(ColorScheme colors) {
    return Text(
      'Курьер принесет вам сдачу.',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colors.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildAmountField(ColorScheme colors) {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,
      enabled: !hasExactAmount,
      decoration: InputDecoration(
        prefixText: 'KGS ',
        prefixStyle: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colors.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colors.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: hasExactAmount ? colors.surfaceContainerHighest : colors.surface,
      ),
      style: theme.textTheme.bodyLarge,
    );
  }

  Widget _buildExactAmountCheckbox(ColorScheme colors) {
    return Row(
      children: [
        Checkbox(
          value: hasExactAmount,
          onChanged: (value) => onExactAmountChanged(value ?? false),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onExactAmountChanged(!hasExactAmount),
            child: Text(
              'У меня ровно ${totalOrderCost.toStringAsFixed(2)} KGS',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasExactAmount ? colors.primary : colors.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

