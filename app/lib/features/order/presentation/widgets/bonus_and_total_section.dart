import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BonusAndTotalSection extends StatefulWidget {
  final DeliveryFormControllers controllers;
  final int totalPrice;
  final double deliveryPrice;

  const BonusAndTotalSection({
    super.key,
    required this.controllers,
    required this.totalPrice,
    required this.deliveryPrice,
  });

  @override
  State<BonusAndTotalSection> createState() => _BonusAndTotalSectionState();
}

class _BonusAndTotalSectionState extends State<BonusAndTotalSection> {
  final FocusNode _bonusFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _bonusFocusNode.addListener(_onBonusFocusChanged);
  }

  @override
  void dispose() {
    _bonusFocusNode.removeListener(_onBonusFocusChanged);
    _bonusFocusNode.dispose();
    super.dispose();
  }

  void _onBonusFocusChanged() {
    if (!_bonusFocusNode.hasFocus) {
      final value = widget.controllers.bonusController.text.trim();
      if (value.isEmpty) {
        final profileState = context.read<ProfileCubit>().state;
        final userBalance = (profileState is ProfileGetLoaded) ? (profileState.userModel.balance ?? 0).toDouble() : 0.0;
        context.read<DeliveryFormCubit>().setBonusAmount(null, userBalance);
      } else {
        _onBonusAmountSubmitted(value);
      }
    }
  }

  void _onBonusAmountSubmitted(String value) {
    final parsedBonus = double.tryParse(value.replaceAll(',', '.'));
    if (parsedBonus != null && parsedBonus >= 0) {
      final profileState = context.read<ProfileCubit>().state;
      final userBalance = (profileState is ProfileGetLoaded) ? (profileState.userModel.balance ?? 0).toDouble() : 0.0;
      final totalOrderCost = widget.totalPrice + widget.deliveryPrice.toInt();

      if (parsedBonus > userBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Недостаточно бонусов. Доступно: ${userBalance.toStringAsFixed(2)} сом'),
            backgroundColor: Colors.red,
          ),
        );
        widget.controllers.bonusController.text = userBalance.toStringAsFixed(2);
        context.read<DeliveryFormCubit>().setBonusAmount(userBalance, userBalance);
        return;
      }

      if (parsedBonus > totalOrderCost) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Сумма бонусов не может превышать стоимость заказа'),
            backgroundColor: Colors.red,
          ),
        );
        widget.controllers.bonusController.text = totalOrderCost.toStringAsFixed(0);
        context.read<DeliveryFormCubit>().setBonusAmount(totalOrderCost.toDouble(), userBalance);
        return;
      }

      context.read<DeliveryFormCubit>().setBonusAmount(
            parsedBonus > 0 ? parsedBonus : null,
            userBalance,
          );
    } else if (value.isEmpty) {
      final profileState = context.read<ProfileCubit>().state;
      final userBalance = (profileState is ProfileGetLoaded) ? (profileState.userModel.balance ?? 0).toDouble() : 0.0;
      context.read<DeliveryFormCubit>().setBonusAmount(null, userBalance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<DeliveryFormCubit, DeliveryFormState>(
      builder: (context, deliveryFormState) {
        if (deliveryFormState is! DeliveryFormLoaded) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            double userBalance = 0;
            if (profileState is ProfileGetLoaded) {
              userBalance = (profileState.userModel.balance ?? 0).toDouble();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Вам доступно ${userBalance.toStringAsFixed(0)} бонусов',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: userBalance == 0 
                            ? theme.colorScheme.onSurface.withOpacity(0.5)
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    Switch(
                      value: deliveryFormState.useBonus,
                      onChanged: userBalance > 0 
                          ? (value) {
                              context.read<DeliveryFormCubit>().toggleBonus(value);
                              if (!value) {
                                widget.controllers.bonusController.clear();
                              }
                            }
                          : null, // Отключаем переключатель, если бонусов нет
                    ),
                  ],
                ),
                if (deliveryFormState.useBonus) ...[
                  const SizedBox(height: 10),
                  TextField(
                    controller: widget.controllers.bonusController,
                    focusNode: _bonusFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    onSubmitted: _onBonusAmountSubmitted,
                    decoration: InputDecoration(
                      hintText: 'бонус',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
