import 'package:flutter/material.dart';

import 'product_card_constants.dart';

/// Increment / decrement counter with editable quantity text field.
class ProductCounterSection extends StatefulWidget {
  const ProductCounterSection({
    super.key,
    required this.quantity,
    this.onDecrement,
    this.onIncrement,
    this.onQuantityChanged,
    this.isCompact = false,
  });

  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final ValueChanged<int>? onQuantityChanged;
  final bool isCompact;

  @override
  State<ProductCounterSection> createState() => _ProductCounterSectionState();
}

class _ProductCounterSectionState extends State<ProductCounterSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant ProductCounterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFieldChanged(String value) {
    final newValue = int.tryParse(value);
    if (newValue != null && newValue > 0) {
      widget.onQuantityChanged?.call(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: ProductCardConstants.counterHeight,
      margin: ProductCardConstants.counterMargin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ProductCardConstants.counterBorderRadius,
        ),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CounterIconButton(
            icon: Icons.remove,
            onPressed: widget.quantity > 0 ? widget.onDecrement : null,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: _onFieldChanged,
            ),
          ),
          const SizedBox(width: 8),
          _CounterIconButton(
            icon: Icons.add,
            onPressed: widget.onIncrement,
          ),
        ],
      ),
    );
  }
}

class _CounterIconButton extends StatelessWidget {
  const _CounterIconButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null;
    return IconButton(
      splashRadius: 20,
      iconSize: 20,
      visualDensity: VisualDensity.compact,
      color: enabled
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurface.withValues(alpha: 0.38),
      onPressed: onPressed,
      icon: Icon(icon),
      disabledColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
    );
  }
}
