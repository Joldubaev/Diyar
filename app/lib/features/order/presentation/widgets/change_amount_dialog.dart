import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeAmountDialog extends StatefulWidget {
  final int totalOrderCost;

  const ChangeAmountDialog({super.key, required this.totalOrderCost});

  // Возвращает int? (сумма сдачи) или null (если нажали "Отмена")
  // Специальное значение -1 или 0 можно использовать для "Без сдачи"
  static Future<int?> show({
    required BuildContext context,
    required int totalOrderCost,
  }) {
    return showDialog<int>(
      context: context,
      builder: (context) => ChangeAmountDialog(totalOrderCost: totalOrderCost),
    );
  }

  @override
  State<ChangeAmountDialog> createState() => _ChangeAmountDialogState();
}

class _ChangeAmountDialogState extends State<ChangeAmountDialog> {
  late final TextEditingController _controller;
  bool _isExactAmount = false;

  @override
  void initState() {
    super.initState();
    // По умолчанию ставим сумму заказа
    _controller = TextEditingController(text: widget.totalOrderCost.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Иконка доллара из макета
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            child: const Icon(Icons.attach_money, color: Colors.green, size: 30),
          ),
          const SizedBox(height: 16),
          Text(
            'С какой суммы понадобится сдача?',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Курьер принесет вам сдачу.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          // Поле ввода суммы
          TextField(
            controller: _controller,
            enabled: !_isExactAmount,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              prefixText: 'KGS ',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),

          // Чекбокс "У меня ровно"
          GestureDetector(
            onTap: () => setState(() => _isExactAmount = !_isExactAmount),
            child: Row(
              children: [
                Checkbox(
                  value: _isExactAmount,
                  onChanged: (val) => setState(() => _isExactAmount = val ?? false),
                  activeColor: Colors.green,
                ),
                Expanded(
                  child: Text('У меня ровно ${widget.totalOrderCost}.00 KGS'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Кнопка Подтвердить
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_isExactAmount) {
                  Navigator.pop(context, 0); // 0 значит "Без сдачи"
                } else {
                  final val = int.tryParse(_controller.text);
                  if (val != null && val >= widget.totalOrderCost) {
                    Navigator.pop(context, val);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Подтвердить', style: TextStyle(color: Colors.white)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отменить', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
