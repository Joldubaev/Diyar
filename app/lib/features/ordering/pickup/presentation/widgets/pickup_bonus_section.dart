import 'package:diyar/core/core.dart';
import 'package:diyar/features/user/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickupBonusSection extends StatelessWidget {
  const PickupBonusSection({
    super.key,
    required this.bonusController,
    required this.bonusFocusNode,
    required this.useBonus,
    required this.onToggleChanged,
    required this.onAmountChanged,
    required this.onAmountSubmitted,
  });

  final TextEditingController bonusController;
  final FocusNode bonusFocusNode;
  final bool useBonus;
  final ValueChanged<bool> onToggleChanged;
  final ValueChanged<double?> onAmountChanged;
  final ValueChanged<String> onAmountSubmitted;

  static final Pattern _bonusAmountPattern = RegExp(r'^\d*\.?\d{0,2}');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        final userBalance = (profileState is ProfileGetLoaded)
            ? (profileState.userModel.balance ?? 0).toDouble()
            : 0.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.colorScheme.surface.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.card_giftcard_rounded,
                        size: 22,
                        color: context.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Вам доступно ${userBalance % 1 == 0 ? userBalance.toInt().toString() : userBalance.toStringAsFixed(1)} бонусов',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: userBalance == 0
                                ? context.colorScheme.onSurface.withValues(alpha: 0.6)
                                : context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Switch.adaptive(
                        value: useBonus,
                        onChanged: userBalance > 0
                            ? (value) {
                                onToggleChanged(value);
                                if (!value) {
                                  bonusController.clear();
                                  onAmountChanged(null);
                                }
                              }
                            : null,
                        activeTrackColor: context.colorScheme.primary.withValues(alpha: 0.6),
                        activeThumbColor: context.colorScheme.primary,
                      ),
                    ],
                  ),
                  if (useBonus) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: bonusController,
                      focusNode: bonusFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(_bonusAmountPattern),
                      ],
                      onSubmitted: onAmountSubmitted,
                      decoration: InputDecoration(
                        hintText: 'Сумма бонусов (сом)',
                        prefixIcon: Icon(
                          Icons.savings_rounded,
                          size: 20,
                          color: context.colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: context.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
