import 'package:flutter/material.dart';
import 'package:diyar/features/order/domain/entities/change_amount_result.dart';
import 'package:diyar/features/order/presentation/widgets/change_amount/change_amount_dialog_actions.dart';
import 'package:diyar/features/order/presentation/widgets/change_amount/change_amount_dialog_content.dart';

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
      Navigator.of(context).pop(const ExactChange());
      return;
    }

    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
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

  void _onExactAmountChanged(bool value) {
    setState(() {
      _hasExactAmount = value;
      if (_hasExactAmount) {
        _amountController.text = widget.totalOrderCost.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChangeAmountDialogContent(
              theme: theme,
              totalOrderCost: widget.totalOrderCost,
              amountController: _amountController,
              hasExactAmount: _hasExactAmount,
              onExactAmountChanged: _onExactAmountChanged,
            ),
            const SizedBox(height: 24),
            ChangeAmountDialogActions(
              theme: theme,
              onConfirm: _onConfirm,
              onCancel: _onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
