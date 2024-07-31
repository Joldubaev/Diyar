import 'package:flutter/material.dart';

class PaymentTypeOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final ValueChanged<String> onSelected;

  const PaymentTypeOption({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelected(title),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}