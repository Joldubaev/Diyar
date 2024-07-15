import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_dialog_widget.dart';

class PickupForm extends StatefulWidget {
  final List<CartItemModel> cart;
  final UserModel? user;
  const PickupForm({Key? key, required this.cart, this.user}) : super(key: key);

  @override
  State<PickupForm> createState() => _PickupFormState();
}

class _PickupFormState extends State<PickupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController =
      TextEditingController(text: '+996');
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    _userName.text = widget.user?.name ?? '';
    _phoneController.text = widget.user?.phone ?? '+996';
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
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );

    if (pickedTime != null) {
      setState(() {
        _timeController.text = '${pickedTime.hour}:${pickedTime.minute}';
      });
    }
  }

  void _submitOrder() {
    context
        .read<OrderCubit>()
        .getPickupOrder(
          PickupOrderModel(
            userPhone: _phoneController.text,
            userName: _userName.text,
            prepareFor: _timeController.text,
            comment: _commentController.text,
            price: context.read<CartCubit>().totalPrice,
            dishesCount: context.read<CartCubit>().dishCount,
            foods: widget.cart
                .map((e) => OrderFoodItem(
                      name: e.food?.name ?? '',
                      price: e.food?.price ?? 0,
                      quantity: e.quantity ?? 1,
                    ))
                .toList(),
          ),
        )
        .then((value) => context.read<CartCubit>().clearCart());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is CreateOrderLoaded) {
          context.router.pushAndPopUntil(
            const MainRoute(),
            predicate: (_) => false,
          );
          showToast(context.l10n.orderIsSuccess);
        } else if (state is CreateOrderError) {
          showToast(context.l10n.someThingIsWrong, isError: true);
        }
      },
      builder: (context, state) {
        if (state is CreateOrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CreateOrderError) {
          return Center(
            child: Text(
              context.l10n.someThingIsWrong,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: theme.colorScheme.error),
            ),
          );
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              CustomInputWidget(
                filledColor: theme.colorScheme.surface,
                controller: _userName,
                hintText: context.l10n.nameExample,
                title: context.l10n.yourName,
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
                title: context.l10n.phone,
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
                filledColor: theme.colorScheme.surface,
                controller: _commentController,
                hintText: '',
                title: context.l10n.comment,
              ),
              const SizedBox(height: 10),
              CustomInputWidget(
                filledColor: theme.colorScheme.surface,
                onTap: _selectTime,
                controller: _timeController,
                hintText: context.l10n.chooseTime,
                title: context.l10n.preparingForThe,
                validator: (value) {
                  if (value == '') {
                    return context.l10n.chooseTime;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.orderPickupAd,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 16),
              ),
              Text(
                context.l10n.address,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 16),
              ),
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
                    showModalBottomSheet(
                        backgroundColor: theme.colorScheme.surface,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        useSafeArea: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return DraggableScrollableSheet(
                            initialChildSize: 0.4,
                            minChildSize: 0.4,
                            expand: false,
                            maxChildSize: 0.4,
                            builder: (context, scrollController) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: ListView(
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${context.l10n.orderPickupAd} ${context.l10n.address}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(fontSize: 16),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: const Icon(Icons.close),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${context.l10n.orderPickupAd} ${context.l10n.address}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 10),
                                      CustomDialogWidget(
                                        title: context.l10n.orderAmount,
                                        description: '$totalPrice сом',
                                      ),
                                      const SizedBox(height: 10),
                                      CustomButton(
                                        title: context.l10n.confirm,
                                        bgColor: AppColors.green,
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    context
                                                        .l10n.yourOrdersConfirm,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: theme
                                                                .colorScheme
                                                                .onSurface),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        context.l10n
                                                            .operatorContact,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: theme
                                                                    .colorScheme
                                                                    .onSurface),
                                                      )
                                                    ],
                                                  ),
                                                  actions: [
                                                    CustomButton(
                                                      title: context.l10n.ok,
                                                      bgColor: AppColors.green,
                                                      onTap: () {
                                                        _submitOrder();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
