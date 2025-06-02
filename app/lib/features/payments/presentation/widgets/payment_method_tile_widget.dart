import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class PaymentMethodTileWidget extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;

  const PaymentMethodTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 17,
                        ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface, size: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
