import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/presentation/widgets/widgets.dart';
import 'package:diyar/features/pick_up/pick_up.dart';
import 'package:diyar/features/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class PickupFormPage extends StatefulWidget {
  final List<CartItemEntity> cart;
  final int totalPrice;
  final int? dishCount;
  const PickupFormPage({
    super.key,
    required this.cart,
    required this.totalPrice,
    this.dishCount,
  });

  @override
  State<PickupFormPage> createState() => _PickupFormPageState();
}

class _PickupFormPageState extends State<PickupFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController(text: '+996');
  final _timeController = TextEditingController();
  final _commentController = TextEditingController();
  final _bonusController = TextEditingController();
  PaymentTypeDelivery _paymentType = PaymentTypeDelivery.cash;
  bool _useBonus = false;
  double? _bonusAmount;

  @override
  void initState() {
    context.read<ProfileCubit>().getUser();
    _userNameController.text = context.read<ProfileCubit>().user?.userName ?? '';
    _phoneController.text = context.read<ProfileCubit>().user?.phone ?? '+996';
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _phoneController.dispose();
    _timeController.dispose();
    _commentController.dispose();
    _bonusController.dispose();
    super.dispose();
  }

  void _showConfirmBottomSheet(BuildContext context, double? bonusAmount) {
    final pickUpCubit = context.read<PickUpCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: pickUpCubit,
        child: ConfirmOrderBottomSheet(
          totalPrice: widget.totalPrice,
          bonusAmount: bonusAmount,
          userName: _userNameController.text,
          userPhone: _phoneController.text,
          time: _timeController.text,
          comment: _commentController.text,
          paymentType: _paymentType,
          onConfirmTap: () {
            // Отправляем заказ
            context.read<PickUpCubit>().createPickupOrder(
                  cart: widget.cart,
                  userName: _userNameController.text,
                  phone: _phoneController.text,
                  time: _timeController.text,
                  comment: _commentController.text,
                  paymentMethod: _paymentType.name,
                  totalPrice: widget.totalPrice,
                  dishCount: widget.dishCount,
                  bonusAmount: bonusAmount,
                );
          },
        ),
      ),
    );
  }

  void _selectTime(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime pickerInitialTime = now.add(const Duration(
      minutes: 15,
    ));
    final currentTimeFromState = _timeController.text;
    if (currentTimeFromState.isNotEmpty) {
      final parts = currentTimeFromState.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          final todaySelection = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );
          if (todaySelection.isAfter(pickerInitialTime)) {
            pickerInitialTime = todaySelection;
          }
        }
      }
    }
    DateTime selectedTime = pickerInitialTime;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Внимание! Время подготовки заказа займет не менее 15 минут',
            style: Theme.of(dialogContext).textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  color: Theme.of(dialogContext).colorScheme.error,
                ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
              height: 240,
              child: Column(children: [
                SizedBox(
                    height: 160,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: pickerInitialTime,
                      minuteInterval: 1,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newTime) {
                        selectedTime = newTime;
                      },
                    )),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      'Отмена',
                      style: Theme.of(dialogContext).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: Theme.of(dialogContext).colorScheme.primary,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final minSelectableTime = now.add(
                        const Duration(minutes: 15),
                      );
                      String timeToSet;
                      if (selectedTime.isAfter(minSelectableTime) || selectedTime.isAtSameMomentAs(minSelectableTime)) {
                        timeToSet =
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                      } else {
                        timeToSet =
                            '${minSelectableTime.hour.toString().padLeft(2, '0')}:${minSelectableTime.minute.toString().padLeft(2, '0')}';
                      }
                      _timeController.text = timeToSet;
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      'Подтвердить',
                      style: Theme.of(dialogContext).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: Theme.of(dialogContext).colorScheme.primary,
                          ),
                    ),
                  ),
                ])
              ])),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return BlocBuilder<PickUpCubit, PickUpState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.primary,
            title: Text(
              l10n.pickup,
              style: theme.textTheme.titleSmall!.copyWith(
                color: theme.colorScheme.onTertiaryFixed,
              ),
            ),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: theme.colorScheme.onTertiaryFixed,
                ),
                onPressed: () => context.router.maybePop()),
          ),
          body: PickupFormWidget(
            formKey: _formKey,
            userNameController: _userNameController,
            phoneController: _phoneController,
            timeController: _timeController,
            commentController: _commentController,
            onTimeSelect: _selectTime,
            currentPaymentType: _paymentType,
            onPaymentTypeChanged: (value) {
              setState(() {
                _paymentType = value;
              });
            },
            bonusController: _bonusController,
            useBonus: _useBonus,
            onBonusToggleChanged: (value) {
              setState(() {
                _useBonus = value;
                if (!_useBonus) {
                  _bonusController.clear();
                  _bonusAmount = null;
                }
              });
            },
            onBonusAmountChanged: (amount) {
              setState(() {
                _bonusAmount = amount;
              });
            },
            totalPrice: widget.totalPrice,
            onConfirmTap: () {
              if (_formKey.currentState!.validate()) {
                // Валидация бонусов перед созданием заказа
                double? finalBonusAmount = _bonusAmount;

                // Если бонусы включены, проверяем значение из контроллера
                if (_useBonus) {
                  final bonusText = _bonusController.text.trim();
                  if (bonusText.isNotEmpty) {
                    final parsedBonus = double.tryParse(bonusText.replaceAll(',', '.'));
                    if (parsedBonus != null && parsedBonus > 0) {
                      finalBonusAmount = parsedBonus;
                    }
                  }
                }

                // Валидация бонусов (если они указаны)
                if (finalBonusAmount != null && finalBonusAmount > 0) {
                  // Проверка баланса пользователя
                  final profileState = context.read<ProfileCubit>().state;
                  final userBalance =
                      (profileState is ProfileGetLoaded) ? (profileState.userModel.balance ?? 0).toDouble() : 0.0;

                  if (finalBonusAmount > userBalance) {
                    showToast('Недостаточно бонусов. Доступно: ${userBalance.toStringAsFixed(2)} сом', isError: true);
                    return;
                  }

                  // Проверка суммы заказа - бонусы не могут превышать стоимость заказа
                  if (finalBonusAmount > widget.totalPrice) {
                    showToast('Сумма бонусов не может превышать стоимость заказа', isError: true);
                    return;
                  }
                }

                // Показываем bottom sheet с данными заказа
                _showConfirmBottomSheet(
                  context,
                  finalBonusAmount,
                );
              }
            },
          ),
        );
      },
    );
  }
}
