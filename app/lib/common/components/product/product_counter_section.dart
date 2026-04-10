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
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ProductCardConstants.counterBorderRadius,
        ),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CounterTapIcon(
            icon: Icons.remove,
            onPressed: widget.quantity > 0 ? widget.onDecrement : null,
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 36,
            height: ProductCardConstants.counterHeight,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              maxLines: 1,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
              ),
              onChanged: _onFieldChanged,
            ),
          ),
          const SizedBox(width: 6),
          _CounterTapIcon(
            icon: Icons.add,
            onPressed: widget.onIncrement,
          ),
        ],
      ),
    );
  }
}

/// Без [IconButton] — у Material минимальная зона ~48px, из‑за неё был overflow в карточке.
class _CounterTapIcon extends StatelessWidget {
  const _CounterTapIcon({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null;
    final color = enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 26,
          height: 26,
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
