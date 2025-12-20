import 'package:flutter/material.dart';
import 'package:diyar/features/order/domain/entities/change_amount_result.dart';

/// Диалог для выбора суммы сдачи
class ChangeAmountDialog extends StatefulWidget {
  final int totalOrderCost;

  const ChangeAmountDialog({
    super.key,
    required this.totalOrderCost,
  });

  /// Показывает диалог выбора суммы сдачи
  ///
  /// Возвращает [ChangeAmountResult] или null, если пользователь отменил
  static Future<ChangeAmountResult?> show({
    required BuildContext context,
    required int totalOrderCost,
  }) async {
    return await showDialog<ChangeAmountResult>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => ChangeAmountDialog(
        totalOrderCost: totalOrderCost,
      ),
    );
  }

  @override
  State<ChangeAmountDialog> createState() => _ChangeAmountDialogState();
}

class _ChangeAmountDialogState extends State<ChangeAmountDialog> {
  late final TextEditingController _amountController;
  bool _hasExactAmount = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.totalOrderCost.toString(),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_hasExactAmount) {
      // Если выбрана опция "У меня ровно X KGS", возвращаем ExactChange
      Navigator.of(context).pop(const ExactChange());
      return;
    }

    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      // Если поле пустое, показываем ошибку
      _showValidationError('Пожалуйста, введите сумму');
      return;
    }

    final amount = int.tryParse(amountText);
    if (amount == null) {
      _showValidationError('Введите корректную сумму');
      return;
    }

    if (amount < widget.totalOrderCost) {
      _showValidationError(
        'Сумма должна быть не меньше ${widget.totalOrderCost} KGS',
      );
      return;
    }

    // Возвращаем CustomChange с введенной суммой
    Navigator.of(context).pop(CustomChange(amount));
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onCancel() {
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Иконка с деньгами
            Container(
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
            ),
            const SizedBox(height: 20),

            // Заголовок
            Text(
              'С какой суммы понадобится сдача?',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Подзаголовок
            Text(
              'Курьер принесет вам сдачу.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),

            // Поле ввода суммы
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              enabled: !_hasExactAmount,
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
                fillColor: _hasExactAmount ? colors.surfaceContainerHighest : colors.surface,
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Чекбокс "У меня ровно X KGS"
            Row(
              children: [
                Checkbox(
                  value: _hasExactAmount,
                  onChanged: (value) {
                    setState(() {
                      _hasExactAmount = value ?? false;
                      if (_hasExactAmount) {
                        _amountController.text = widget.totalOrderCost.toString();
                      }
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _hasExactAmount = !_hasExactAmount;
                        if (_hasExactAmount) {
                          _amountController.text = widget.totalOrderCost.toString();
                        }
                      });
                    },
                    child: Text(
                      'У меня ровно ${widget.totalOrderCost.toStringAsFixed(2)} KGS',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _hasExactAmount ? colors.primary : colors.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Кнопка "Подтвердить"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Подтвердить',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Кнопка "Отменить"
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.onSurface,
                  side: BorderSide(
                    color: colors.outline.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Отменить',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
