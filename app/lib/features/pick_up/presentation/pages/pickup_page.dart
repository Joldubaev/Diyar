import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/pick_up/pick_up.dart';
import 'package:diyar/features/profile/profile.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    context.read<ProfileCubit>().getUser();
    final profileCubit = context.read<ProfileCubit>();
    final userName = profileCubit.user?.userName ?? '';
    final userPhone = profileCubit.user?.phone ?? '+996';

    _userNameController.text = userName;
    _phoneController.text = userPhone;

    context.read<PickUpCubit>().initializeForm(
          userName: userName,
          userPhone: userPhone,
        );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _phoneController.dispose();
    _timeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _selectTime(BuildContext context) {
    final cubit = context.read<PickUpCubit>();
    final minimumTime = cubit.getMinimumTime();
    DateTime initialTime = minimumTime;

    // Если уже выбрано время, используем его как начальное
    if (_timeController.text.isNotEmpty) {
      final parsedTime = cubit.parseTimeString(_timeController.text);
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
          cubit.validateAndSetTime(selectedTime);
          _timeController.text = cubit.formatTime(selectedTime);
        },
      ),
    );
  }

  PaymentTypeDelivery _getPaymentTypeFromState(PickUpState state) {
    if (state is PickUpFormLoaded) {
      return PaymentTypeDelivery.values.firstWhere(
        (e) => e.name == state.paymentType,
        orElse: () => PaymentTypeDelivery.cash,
      );
    }
    return PaymentTypeDelivery.cash;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return BlocConsumer<PickUpCubit, PickUpState>(
      listener: (context, state) {
        if (state is CreatePickUpOrderLoaded) {
          context.read<CartBloc>().add(ClearCart());
          final paymentType = PaymentTypeDelivery.values.firstWhere(
            (e) => e.name == state.paymentType,
            orElse: () => PaymentTypeDelivery.cash,
          );

          if (paymentType == PaymentTypeDelivery.online) {
            context.router.push(
              PaymentsRoute(
                orderNumber: state.message,
                amount: state.totalPrice.toString(),
              ),
            );
            Navigator.of(context).pop();
          } else {
            _showSuccessDialog(context, theme, l10n);
          }
        } else if (state is CreatePickUpOrderError) {
          showToast(state.message, isError: true);
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
            onConfirmTap: () {
              if (_formKey.currentState!.validate()) {
                context.read<PickUpCubit>().submitPickupOrder(
                      cartItems: widget.cart,
                      userName: _userNameController.text,
                      userPhone: _phoneController.text,
                      prepareFor: _timeController.text,
                      comment: _commentController.text.isEmpty
                          ? null
                          : _commentController.text,
                      totalPrice: widget.totalPrice,
                      dishCount: widget.dishCount ?? 0,
                    );
              }
            },
          ),
        );
      },
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(
              l10n.yourOrdersConfirm,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontSize: 16,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.operatorContact,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                SubmitButtonWidget(
                  textStyle: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                  title: l10n.ok,
                  bgColor: AppColors.green,
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    context.router.pushAndPopUntil(
                      const MainRoute(),
                      predicate: (_) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
