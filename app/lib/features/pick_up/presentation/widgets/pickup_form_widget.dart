import 'package:diyar/common/components/components.dart';
import 'package:flutter/material.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart' hide PaymentTypeDelivery;
import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PickupFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController userNameController;
  final TextEditingController commentController;
  final TextEditingController timeController;
  final TextEditingController bonusController;
  final VoidCallback onConfirmTap;
  final Function(BuildContext) onTimeSelect;
  final PaymentTypeDelivery currentPaymentType;
  final ValueChanged<PaymentTypeDelivery> onPaymentTypeChanged;
  final bool useBonus;
  final ValueChanged<bool> onBonusToggleChanged;
  final ValueChanged<double?> onBonusAmountChanged;
  final int totalPrice;

  const PickupFormWidget({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.userNameController,
    required this.commentController,
    required this.timeController,
    required this.bonusController,
    required this.onConfirmTap,
    required this.onTimeSelect,
    required this.currentPaymentType,
    required this.onPaymentTypeChanged,
    required this.useBonus,
    required this.onBonusToggleChanged,
    required this.onBonusAmountChanged,
    required this.totalPrice,
  });

  @override
  State<PickupFormWidget> createState() => _PickupFormWidgetState();
}

class _PickupFormWidgetState extends State<PickupFormWidget> {
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
      final value = widget.bonusController.text.trim();
      if (value.isEmpty) {
        widget.onBonusAmountChanged(null);
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

      if (parsedBonus > userBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Недостаточно бонусов. Доступно: ${userBalance.toStringAsFixed(2)} сом'),
            backgroundColor: Colors.red,
          ),
        );
        widget.bonusController.text = userBalance.toStringAsFixed(2);
        widget.onBonusAmountChanged(userBalance);
        return;
      }

      if (parsedBonus > widget.totalPrice) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Сумма бонусов не может превышать стоимость заказа'),
            backgroundColor: Colors.red,
          ),
        );
        widget.bonusController.text = widget.totalPrice.toStringAsFixed(0);
        widget.onBonusAmountChanged(widget.totalPrice.toDouble());
        return;
      }

      widget.onBonusAmountChanged(parsedBonus > 0 ? parsedBonus : null);
    } else if (value.isEmpty) {
      widget.onBonusAmountChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CustomInputWidget(
            titleColor: theme.colorScheme.onSurface,
            filledColor: theme.colorScheme.surface,
            controller: widget.userNameController,
            hintText: l10n.yourName,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Введите имя';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          PhoneNumberMask(
            hintText: '+996 (___) __-__-__',
            textController: widget.phoneController,
            hint: l10n.phone,
            formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
            textInputType: TextInputType.phone,
            validator: (value) {
              final phone = value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
              if (phone.length < 12) {
                return 'Введите корректный номер';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
            titleColor: theme.colorScheme.onSurface,
            filledColor: theme.colorScheme.surface,
            controller: widget.commentController,
            hintText: l10n.comment,
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
            filledColor: theme.colorScheme.surface,
            controller: widget.timeController,
            isReadOnly: true,
            onTap: () => widget.onTimeSelect(context),
            hintText: l10n.chooseTime,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Выберите время';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // PaymentTypeSelector(
          //   currentPaymentType: currentPaymentType,
          //   onChanged: onPaymentTypeChanged,
          // ),
          const SizedBox(height: 16),
          // Секция с бонусами
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              double userBalance = 0;
              if (profileState is ProfileGetLoaded) {
                userBalance = (profileState.userModel.balance ?? 0).toDouble();
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Вам доступно ${userBalance % 1 == 0 ? userBalance.toInt().toString() : userBalance.toStringAsFixed(1)} бонусов',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: widget.useBonus,
                        onChanged: widget.onBonusToggleChanged,
                      ),
                    ],
                  ),
                  if (widget.useBonus) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: widget.bonusController,
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
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          Text(l10n.orderPickupAd, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
          Text(l10n.address, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
          const SizedBox(height: 10),
          SubmitButtonWidget(
            title: l10n.confirmOrder,
            bgColor: Theme.of(context).colorScheme.primary,
            textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),
            onTap: widget.onConfirmTap,
          ),
        ],
      ),
    );
  }
}
