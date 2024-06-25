import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:diyar/features/order/data/models/create_order_model.dart';
import 'package:diyar/features/order/data/models/pickup_order_model.dart';
import 'package:diyar/features/order/presentation/cubit/order_cubit.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/features/auth/presentation/widgets/phone_number.dart';
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

  void _showTotalPriceDialog(double totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${context.l10n.orderPickupAd} ${context.l10n.address}',
            style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ожидания заказа 20 минут',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: AppColors.black1,
                ),
              ),
              const Divider(),
              CustomDialogWidget(
                title: 'Сумма заказа:',
                description: '$totalPrice сом',
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                CustomButton(
                  title: 'Подтвердить',
                  bgColor: AppColors.green,
                  onTap: () {
                    _submitOrder();
                  },
                ),
                const SizedBox(width: 10),
                CustomButton(
                  title: 'Отменить',
                  bgColor: AppColors.red,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
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
                  .copyWith(color: AppColors.red),
            ),
          );
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              CustomInputWidget(
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
                controller: _commentController,
                hintText: '',
                title: context.l10n.comment,
              ),
              const SizedBox(height: 10),
              CustomInputWidget(
                onTap: _selectTime,
                controller: _timeController,
                hintText: 'Выберите время',
                title: context.l10n.preparingForThe,
                validator: (value) {
                  if (value == '') {
                    return 'Выберите время';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.orderPickupAd,
                style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
              ),
              Text(
                context.l10n.address,
                style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 10),
              SubmitButtonWidget(
                title: context.l10n.confirmOrder,
                bgColor: theme.primaryColor,
                textStyle:
                    theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    double totalPrice = _calculateTotalPrice();
                    _showTotalPriceDialog(totalPrice);
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
