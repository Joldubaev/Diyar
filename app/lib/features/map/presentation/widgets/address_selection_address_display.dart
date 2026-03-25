import 'package:flutter/material.dart';

class AddressSelectionAddressDisplay extends StatelessWidget {
  final ThemeData theme;
  final String? address;
  final bool isLoading;

  const AddressSelectionAddressDisplay({
    super.key,
    required this.theme,
    required this.address,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.place, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Город, улица и дом',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                if (isLoading)
                  _AddressLoadingIndicator(theme: theme)
                else
                  _AddressText(theme: theme, address: address),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressLoadingIndicator extends StatelessWidget {
  final ThemeData theme;

  const _AddressLoadingIndicator({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text('Определяем адрес...', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _AddressText extends StatelessWidget {
  final ThemeData theme;
  final String? address;

  const _AddressText({required this.theme, required this.address});

  @override
  Widget build(BuildContext context) {
    return Text(
      address ?? 'Переместите карту',
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

