import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/profile/presentation/presentation.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../widgets/info_dialog_widget.dart';

@RoutePage()
class PickupFormPage extends StatefulWidget {
  final List<CartItemEntity> cart;
  final int totalPrice;
  const PickupFormPage({super.key, required this.cart, required this.totalPrice});

  @override
  State<PickupFormPage> createState() => _PickupFormPageState();
}

class _PickupFormPageState extends State<PickupFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController(text: '+996');
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
    return widget.cart.fold(0, (total, item) => total + (item.food?.price ?? 0) * (item.quantity ?? 1));
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 16, color: Theme.of(context).colorScheme.error),
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
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 16, color: Theme.of(context).colorScheme.primary),
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
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 16, color: Theme.of(context).colorScheme.primary),
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
      showToast(context.l10n.chooseTime);
      return;
    }

    final timeParts = selectedTime.split(':');
    if (timeParts.length != 2) {
      showToast("Invalid time format. Please use HH:MM");
      return;
    }
    final hour = int.tryParse(timeParts[0]);

    if (hour == null) {
      showToast("Invalid time format. Hour is not a number.");
      return;
    }

    if ((hour >= 23) || (hour < 10)) {
      showToast("Orders can only be placed between 10:00 and 22:59.");
      return;
    }

    int currentTotalItems = 0;
    final cartState = context.read<CartBloc>().state;
    if (cartState is CartLoaded) {
      currentTotalItems = cartState.totalItems;
    } else {
      log("Warning: Cart state is not CartLoaded in _submitOrder. Using widget.cart.length as fallback for item count.");
      currentTotalItems = widget.cart.length;
    }

    final List<FoodItemOrderEntity> foodEntities = widget.cart
        .map((cartItem) {
          final foodEntityFromCart = cartItem.food;
          if (foodEntityFromCart == null) {
            log("Error: cartItem.food is null. Skipping this item.");
            return null;
          }

          final String? dishId = foodEntityFromCart.id;
          final String? name = foodEntityFromCart.name;
          final int? price = foodEntityFromCart.price;
          final int quantity = cartItem.quantity ?? 1;

          if (dishId == null || name == null || price == null) {
            log("Error: One of the required fields (dishId, name, price) is null for a food item. Skipping this item. ID: $dishId, Name: $name, Price: $price");
            return null;
          }
          return FoodItemOrderEntity(
            dishId: dishId,
            name: name,
            price: price,
            quantity: quantity,
          );
        })
        .whereType<FoodItemOrderEntity>()
        .toList();

    if (foodEntities.isEmpty && widget.cart.isNotEmpty) {
      log("Error: All cart items had null food entities or missing required fields. Cannot create order.");
      showToast("Error processing cart items. Please try again.");
      return;
    }

    final pickupOrderEntity = PickupOrderEntity(
      userPhone: _phoneController.text,
      userName: _userName.text,
      prepareFor: _timeController.text,
      comment: _commentController.text,
      price: widget.totalPrice,
      dishesCount: currentTotalItems,
      foods: foodEntities,
    );

    context.read<OrderCubit>().getPickupOrder(pickupOrderEntity);
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
          _userName.text = state.userModel.userName ?? '';
          _phoneController.text = state.userModel.phone;
        }
        return BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is CreateOrderLoaded) {
              context.read<CartBloc>().add(ClearCart());

              final currentRoute = ModalRoute.of(context);
              if (currentRoute is ModalBottomSheetRoute) {
                if (mounted) Navigator.of(context).pop();
              }

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return PopScope(
                    canPop: false,
                    child: AlertDialog(
                      title: Text(context.l10n.yourOrdersConfirm,
                          style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.operatorContact,
                              style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurface)),
                          const SizedBox(height: 10),
                          SubmitButtonWidget(
                              textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),
                              title: context.l10n.ok,
                              bgColor: AppColors.green,
                              onTap: () {
                                if (mounted) Navigator.of(context).pop();
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
              final currentRoute = ModalRoute.of(context);
              if (currentRoute is ModalBottomSheetRoute) {
                if (mounted) Navigator.of(context).pop();
              }
              final errorMessage = state.message.isNotEmpty ? state.message : context.l10n.someThingIsWrong;
              showToast(errorMessage, isError: true);
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
                      icon: Icon(Icons.arrow_back_ios_sharp, color: theme.colorScheme.onTertiaryFixed),
                      onPressed: () => context.router.maybePop())),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
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
                      formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
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
                    Text(context.l10n.orderPickupAd, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                    Text(context.l10n.address, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    SubmitButtonWidget(
                      title: context.l10n.confirmOrder,
                      bgColor: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),
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

  Future<dynamic> showBottomDialog(ThemeData theme, BuildContext context, double totalPrice) {
    return showModalBottomSheet(
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                            child: Text('${context.l10n.orderPickupAd} ${context.l10n.address}',
                                style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16))),
                        IconButton(onPressed: () => context.maybePop(), icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  InfoDialogWidget(title: context.l10n.orderAmount, description: '${widget.totalPrice} сом'),
                  const SizedBox(height: 10),
                  BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      return SubmitButtonWidget(
                          isLoading: state is CreateOrderLoading,
                          textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),
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
