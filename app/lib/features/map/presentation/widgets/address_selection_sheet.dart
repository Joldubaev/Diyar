import 'package:diyar/common/components/components.dart';
import 'package:flutter/material.dart';

/// Нижняя панель выбора адреса: поиск, отображение адреса, кнопка «Продолжить»
class AddressSelectionSheet extends StatelessWidget {
  final ThemeData theme;
  final String? address;
  final bool isLoading;
  final VoidCallback onSearchPressed;
  final VoidCallback onConfirm;

  const AddressSelectionSheet({
    super.key,
    required this.theme,
    required this.address,
    required this.isLoading,
    required this.onSearchPressed,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: CustomInputWidget(
                filledColor: theme.colorScheme.surface,
                hintText: 'Поиск адреса',
                leading: const Icon(Icons.search),
                onTap: onSearchPressed,
                isReadOnly: true,
              ),
            ),
            const SizedBox(height: 12),
            _buildAddressDisplay(),
            const SizedBox(height: 16),
            _buildSubmitButton(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDisplay() {
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
                isLoading ? _buildLoadingIndicator() : _buildAddressText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
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

  Widget _buildAddressText() {
    return Text(
      address ?? 'Переместите карту',
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: SubmitButtonWidget(
        onTap: (address != null && !isLoading) ? onConfirm : null,
        bgColor: theme.colorScheme.primary,
        title: 'Продолжить',
        textStyle: theme.textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
