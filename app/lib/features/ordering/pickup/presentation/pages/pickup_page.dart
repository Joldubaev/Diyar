import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/ordering/delivery/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/ordering/pickup/pick_up.dart';
import 'package:diyar/features/user/profile/profile.dart';
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

  late final PickUpCubit _pickUpCubit;

  bool _useBonus = false;
  double? _bonusAmount;

  @override
  void initState() {
    super.initState();
    _pickUpCubit = sl<PickUpCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeForm());
  }

  @override
  void dispose() {
    _pickUpCubit.close();
    _userNameController.dispose();
    _phoneController.dispose();
    _timeController.dispose();
    _commentController.dispose();
    _bonusController.dispose();
    super.dispose();
  }

  /// Инициализация формы с данными пользователя
  Future<void> _initializeForm() async {
    // Инициализируем форму пикапа
    _pickUpCubit.initializeForm(
      paymentType: PaymentTypeDelivery.cash,
      userName: '',
      userPhone: '+996',
      totalPrice: widget.totalPrice,
    );

    // Получаем данные профиля для подстановки
    try {
      final profileCubit = context.read<ProfileCubit>();
      await profileCubit.getUser();

      if (!mounted) return;

      final user = profileCubit.user;
      if (user != null) {
        setState(() {
          _userNameController.text = user.userName ?? '';
          _phoneController.text = user.phone ?? '+996';
        });
        _pickUpCubit.updateFormData(
          userName: user.userName ?? '',
          userPhone: user.phone ?? '+996',
        );
      }
    } catch (_) {
      // Игнорируем ошибки профиля - форма работает с пустыми полями
    }
  }

  /// Валидация суммы бонусов
  Future<bool> _validateBonusAmount(double amount) async {
    final profileState = context.read<ProfileCubit>().state;
    final userBalance = (profileState is ProfileGetLoaded) ? (profileState.userModel.balance ?? 0).toDouble() : 0.0;

    if (amount > userBalance) {
      showToast(
        'Недостаточно бонусов. Доступно: ${userBalance.toStringAsFixed(0)} сом',
        isError: true,
      );
      return false;
    }

    if (amount > widget.totalPrice) {
      showToast('Сумма бонусов не может превышать стоимость заказа', isError: true);
      return false;
    }

    return true;
  }

  /// Обработка переключения бонусов
  void _onBonusToggleChanged(bool value) {
    setState(() {
      _useBonus = value;
      if (!_useBonus) {
        _bonusController.clear();
        _bonusAmount = null;
        _pickUpCubit.setBonusAmount(null, 0.0);
      }
    });
  }

  /// Обработка изменения суммы бонусов
  void _onBonusAmountChanged(double? amount) {
    setState(() {
      _bonusAmount = amount;
    });

    final profileState = context.read<ProfileCubit>().state;
    final userBalance = (profileState is ProfileGetLoaded) ? (profileState.userModel.balance ?? 0).toDouble() : 0.0;

    _pickUpCubit.setBonusAmount(amount, userBalance);
  }

  /// Выбор времени готовности заказа
  void _selectTime(BuildContext context) {
    final minimumTime = _pickUpCubit.getMinimumTime();

    DateTime initialTime = minimumTime;

    // Если уже выбрано время, используем его как начальное
    if (_timeController.text.isNotEmpty) {
      final parsedTime = _pickUpCubit.parseTimeString(_timeController.text);
      if (parsedTime != null && parsedTime.isAfter(minimumTime)) {
        initialTime = parsedTime;
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) => PickupTimePickerDialog(
        initialTime: initialTime,
        minimumTime: minimumTime,
        onTimeSelected: (selectedTime) {
          _pickUpCubit.validateAndSetTime(selectedTime);
          _timeController.text = _pickUpCubit.formatTime(selectedTime);
        },
      ),
    );
  }

  /// Получение типа оплаты из состояния
  PaymentTypeDelivery _getPaymentTypeFromState(PickUpState state) {
    if (state is PickUpFormLoaded) {
      return state.paymentType;
    }
    return PaymentTypeDelivery.cash;
  }

  /// Показ bottom sheet подтверждения заказа
  void _showConfirmBottomSheet(BuildContext context) {
    final pickUpCubit = _pickUpCubit;
    final currentState = _pickUpCubit.state;
    if (currentState is! PickUpFormLoaded) return;

    final paymentType = _getPaymentTypeFromState(currentState);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: pickUpCubit,
        child: ConfirmOrderBottomSheet(
          totalOrderCost: currentState.totalOrderCost,
          totalPrice: currentState.totalPrice,
          bonusAmount: currentState.bonusAmount,
          userName: _userNameController.text,
          userPhone: _phoneController.text,
          time: _timeController.text,
          comment: _commentController.text,
          paymentType: paymentType,
          onConfirmTap: () => _submitOrder(pickUpCubit),
        ),
      ),
    );
  }

  /// Отправка заказа
  void _submitOrder(PickUpCubit pickUpCubit) {
    pickUpCubit.createPickupOrder(
      cart: widget.cart,
      userName: _userNameController.text,
      phone: _phoneController.text,
      time: _timeController.text,
      comment: _commentController.text,
      paymentMethod: _getPaymentTypeFromState(pickUpCubit.state).name,
    );
  }

  /// Обработка подтверждения заказа
  void _onConfirmTap() {
    if (!_formKey.currentState!.validate()) return;

    // Валидация бонусов если они используются
    if (_useBonus && _bonusAmount != null && _bonusAmount! > 0) {
      _validateBonusAmount(_bonusAmount!).then((isValid) {
        if (isValid) {
          _finalizeAndShowConfirm();
        }
      });
    } else {
      _finalizeAndShowConfirm();
    }
  }

  /// Финализация перед показом bottom sheet
  void _finalizeAndShowConfirm() {
    final profileState = context.read<ProfileCubit>().state;
    final userBalance = (profileState is ProfileGetLoaded) ? (profileState.userModel.balance ?? 0).toDouble() : 0.0;

    _pickUpCubit.setBonusAmount(_bonusAmount, userBalance);
    _showConfirmBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BlocProvider<PickUpCubit>.value(
      value: _pickUpCubit,
      child: BlocConsumer<PickUpCubit, PickUpState>(
        listener: (context, state) {
          if (state is CreatePickUpOrderLoaded) {
            context.read<CartBloc>().add(ClearCart());
          } else if (state is CreatePickUpOrderError) {
            showToast(state.message, isError: true);
          } else if (state is PickUpFormLoaded && state.bonusError != null) {
            showToast(state.bonusError!, isError: true);
          }
        },
        builder: (context, state) {
          final paymentType = _getPaymentTypeFromState(state);

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
                onPressed: () => context.router.maybePop(),
              ),
            ),
            body: PickupFormWidget(
              formKey: _formKey,
              userNameController: _userNameController,
              phoneController: _phoneController,
              timeController: _timeController,
              commentController: _commentController,
              onTimeSelect: _selectTime,
              currentPaymentType: paymentType,
              onPaymentTypeChanged: (value) {
                context.read<PickUpCubit>().changePaymentType(value);
              },
              bonusController: _bonusController,
              useBonus: _useBonus,
              onBonusToggleChanged: _onBonusToggleChanged,
              onBonusAmountChanged: _onBonusAmountChanged,
              totalPrice: widget.totalPrice,
              onConfirmTap: _onConfirmTap,
            ),
          );
        },
      ),
    );
  }
}
