import 'package:auto_route/auto_route.dart';
import '../../../../core/router/routes.gr.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../features.dart';
import '../../../profile/presentation/presentation.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../widgets/custom_dialog_widget.dart';

@RoutePage()
class PickupFormPage extends StatefulWidget {
  final List<CartItemModel> cart;
  final int totalPrice;
  const PickupFormPage({super.key, required this.cart, required this.totalPrice});

  @override
  State<PickupFormPage> createState() => _PickupFormPageState();
}

class _PickupFormPageState extends State<PickupFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController =
      TextEditingController(text: '+996');
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    context.read<ProfileCubit>().getUser();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _userName.dispose();
    _commentController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  double _calculateTotalPrice() {
    return widget.cart.fold(
        0,
        (total, item) =>
            total + (item.food?.price ?? 0) * (item.quantity ?? 1));
  }

  void _selectTime() async {
    DateTime now = DateTime.now();
    DateTime initialTime = now.add(const Duration(minutes: 15));
    DateTime selectedTime = initialTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Внимание! Время подготовки заказа займет не менее 15 минут',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16, color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 240,
            child: Column(
              children: [
                SizedBox(
                  height: 160,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: initialTime,
                    minuteInterval: 1,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newTime) {
                      selectedTime = newTime;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Отмена',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedTime.isAfter(initialTime)) {
                          _timeController.text =
                              '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                        } else {
                          _timeController.text =
                              '${initialTime.hour.toString().padLeft(2, '0')}:${initialTime.minute.toString().padLeft(2, '0')}';
                        }
                        context.maybePop();
                      },
                      child: Text(
                        'Подтвердить',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitOrder() {
    final selectedTime = _timeController.text;

    if (selectedTime.isEmpty) {
      showToast('Please select a valid time.');
      return;
    }

    final hour = int.parse(selectedTime.split(':')[0]);

    if ((hour >= 23) || (hour < 10)) {
      showToast('Orders cannot be placed between 23:00 and 10:00.');
      return;
    }

    context
        .read<OrderCubit>()
        .getPickupOrder(PickupOrderModel(
            userPhone: _phoneController.text,
            userName: _userName.text,
            prepareFor: _timeController.text,
            comment: _commentController.text,
            price: widget.totalPrice,
            dishesCount: context.read<CartCubit>().dishCount,
            foods: widget.cart
                .map((e) => OrderFoodItem(
                      name: e.food?.name ?? '',
                      price: e.food?.price ?? 0,
                      quantity: e.quantity ?? 1,
                    ))
                .toList()))
        .then(
          (value) {
            if (mounted) {
              context.read<CartCubit>().clearCart();
            }
          }
        );
    context.read<CartCubit>().dishCount = 0;
    context.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileGetLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProfileGetLoaded) {
          _userName.text = state.userModel.name ?? '';
          _phoneController.text = state.userModel.phone ?? '+996';
        }
        return BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is CreateOrderLoaded) {
              showDialog(
                context: context,
                builder: (context) {
                  return PopScope(
                    canPop: false,
                    child: AlertDialog(
                      title: Text(context.l10n.yourOrdersConfirm,
                          style: theme.textTheme.bodyLarge!
                              .copyWith(fontSize: 16)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.operatorContact,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onSurface)),
                          const SizedBox(height: 10),
                          SubmitButtonWidget(
                              textStyle: theme.textTheme.bodyMedium!
                                  .copyWith(color: theme.colorScheme.surface),
                              title: context.l10n.ok,
                              bgColor: AppColors.green,
                              onTap: () {
                                context.router.pushAndPopUntil(
                                  const MainRoute(),
                                  predicate: (_) => false,
                                );
                              })
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is CreateOrderError) {
              showToast(context.l10n.someThingIsWrong, isError: true);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: theme.colorScheme.primary,
                  title: Text(
                    context.l10n.pickup,
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: theme.colorScheme.onTertiaryFixed,
                    ),
                  ),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_sharp,
                          color: theme.colorScheme.onTertiaryFixed),
                      onPressed: () => context.router.maybePop())),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding:
                      const EdgeInsets.all(20),
                  children: [
                    CustomInputWidget(
                      titleColor: theme.colorScheme.onSurface,
                      filledColor: theme.colorScheme.surface,
                      controller: _userName,
                      hintText: context.l10n.yourName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return context.l10n.pleaseEnterName;
                        } else if (value.length < 3) {
                          return context.l10n.pleaseEnterCorrectName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    PhoneNumberMask(
                      hintText: '+996 (___) __-__-__',
                      textController: _phoneController,
                      hint: context.l10n.phone,
                      formatter:
                          MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
                      textInputType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return context.l10n.pleaseEnterPhone;
                        } else if (value.length < 10) {
                          return context.l10n.pleaseEnterCorrectPhone;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomInputWidget(
                      titleColor: theme.colorScheme.onSurface,
                      filledColor: theme.colorScheme.surface,
                      controller: _commentController,
                      hintText: context.l10n.comment,
                    ),
                    const SizedBox(height: 10),
                    CustomInputWidget(
                      filledColor: theme.colorScheme.surface,
                      onTap: _selectTime,
                      controller: _timeController,
                      hintText: context.l10n.chooseTime,
                      validator: (value) {
                        if (value == '') {
                          return context.l10n.chooseTime;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(context.l10n.orderPickupAd,
                        style:
                            theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                    Text(context.l10n.address,
                        style:
                            theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    SubmitButtonWidget(
                      title: context.l10n.confirmOrder,
                      bgColor: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: theme.colorScheme.surface),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          double totalPrice = _calculateTotalPrice();
                          showBottomDialog(theme, context, totalPrice);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> showBottomDialog(
      ThemeData theme, BuildContext context, double totalPrice) {
    return showModalBottomSheet(
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.3,
          expand: false,
          maxChildSize: 0.3,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                                '${context.l10n.orderPickupAd} ${context.l10n.address}',
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(fontSize: 16))),
                        IconButton(
                            onPressed: () => context.maybePop(),
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  CustomDialogWidget(
                      title: context.l10n.orderAmount,
                      description: '${widget.totalPrice} сом'),
                  const SizedBox(height: 10),
                  BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      return SubmitButtonWidget(
                          isLoading: state is CreateOrderLoading,
                          textStyle: theme.textTheme.bodyMedium!
                              .copyWith(color: theme.colorScheme.surface),
                          title: context.l10n.confirm,
                          bgColor: AppColors.green,
                          onTap: _submitOrder);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
