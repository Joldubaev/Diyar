import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/cart/data/models/models.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class DeliveryFormPage extends StatefulWidget {
  final List<CartItemModel> cart;
  final UserModel? user;
  const DeliveryFormPage({super.key, required this.cart, this.user});

  @override
  State<DeliveryFormPage> createState() => _DeliveryFormPageState();
}

class _DeliveryFormPageState extends State<DeliveryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController =
      TextEditingController(text: '+996');
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _intercomController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _entranceController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _sdachaController = TextEditingController();

  PaymentTypeDelivery _paymentType = PaymentTypeDelivery.cash;

  @override
  void initState() {
    _userName.text = widget.user?.name ?? '';
    _phoneController.text = widget.user?.phone ?? '+996';
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _houseController.dispose();
    _apartmentController.dispose();
    _intercomController.dispose();
    _floorController.dispose();
    _entranceController.dispose();
    _commentController.dispose();
    _userName.dispose();
    super.dispose();
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
        _addressController.text = context.read<OrderCubit>().address;

        log(_addressController.text);

        // Разделение строки по запятой
        List<String> parts = _addressController.text.split(',');

        // Получение последней части и удаление начальных и конечных пробелов
        String lastPart = parts.last.trim();

        // Извлечение последнего числа из строки
        RegExp regExp = RegExp(r'(\d+[^\s]*)$');
        Match? match = regExp.firstMatch(lastPart);

        if (match != null) {
          String lastNumber = match.group(0)!;
          _houseController.text = lastNumber;
          log('Последнее число: $lastNumber');
        } else {
          log('Число не найдено');
          _houseController.text = '';
        }

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
                  }),
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
              CustomInputWidget(
                onTap: () => context.router.push(const OrderMapRoute()),
                isReadOnly: true,
                hintText: context.l10n.chooseOnMap,
                title: context.l10n.adress,
                controller: _addressController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.l10n.pleaseEnterAddress;
                  } else if (value.length < 3) {
                    return context.l10n.pleaseEnterCorrectAddress;
                  }
                  return null;
                },
              ),
              CustomInputWidget(
                  inputType: TextInputType.text,
                  controller: _houseController,
                  hintText: context.l10n.houseNumber,
                  title: context.l10n.houseNumber,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return context.l10n.pleaseEnterHouseNumber;
                    }
                    return null;
                  }),
              CustomInputWidget(
                  inputType: TextInputType.text,
                  controller: _apartmentController,
                  hintText: '',
                  title: context.l10n.ofice),
              CustomInputWidget(
                inputType: TextInputType.number,
                controller: _intercomController,
                hintText: '',
                title: context.l10n.entranceNumber,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomInputWidget(
                      controller: _floorController,
                      hintText: context.l10n.floor,
                      title: context.l10n.floor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomInputWidget(
                      controller: _entranceController,
                      hintText: '',
                      title: context.l10n.entrance,
                    ),
                  ),
                ],
              ),
              CustomInputWidget(
                controller: _commentController,
                hintText: 'Ваша еда очень вкусная ...',
                title: context.l10n.comment,
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.paymentMethod,
                style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
              ),
              RadioListTile<PaymentTypeDelivery>(
                activeColor: theme.primaryColor,
                title: Text(context.l10n.cash),
                value: PaymentTypeDelivery.cash,
                groupValue: _paymentType,
                onChanged: (PaymentTypeDelivery? value) {
                  setState(() {
                    _paymentType = value!;
                  });
                },
              ),
              if (_paymentType == PaymentTypeDelivery.cash)
                CustomInputWidget(
                  controller: _sdachaController,
                  hintText: context.l10n.change,
                  title: context.l10n.change,
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return context.l10n.confirmOrder;
                    } else if (value.length < 2) {
                      return context.l10n.confirmOrder;
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 10),
              SubmitButtonWidget(
                  title: context.l10n.confirmOrder,
                  bgColor: theme.primaryColor,
                  textStyle:
                      theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final totalPrice = context.read<CartCubit>().totalPrice;
                      final deliveryPrice =
                          context.read<OrderCubit>().deliveryPrice;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Сумма оплаты c доставкой.'),
                            content: Text('${deliveryPrice + totalPrice} сом',
                                style: theme.textTheme.titleSmall!),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<OrderCubit>()
                                      .createOrder(
                                        CreateOrderModel(
                                          userPhone: _phoneController.text,
                                          userName: _userName.text,
                                          address: _addressController.text,
                                          comment: _commentController.text,
                                          price: totalPrice,
                                          deliveryPrice: 0,
                                          houseNumber: _houseController.text,
                                          kvOffice: _apartmentController.text,
                                          intercom: _intercomController.text,
                                          floor: _floorController.text,
                                          entrance: _entranceController.text,
                                          paymentMethod: _paymentType.name,
                                          sdacha: int.tryParse(
                                                  _sdachaController.text) ??
                                              0,
                                          foods: widget.cart
                                              .map((e) => OrderFoodItem(
                                                    name: e.food?.name ?? '',
                                                    price: e.food?.price ?? 0,
                                                    quantity: e.quantity ?? 1,
                                                  ))
                                              .toList(),
                                        ),
                                      )
                                      .then((value) {
                                    context.read<CartCubit>().clearCart();
                                    context.maybePop();
                                  });
                                },
                                child: const Text('Подтвердить'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Отменить'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }),
            ],
          ),
        );
      },
    );
  }
}

enum PaymentTypeDelivery { cash, card, online }

  // RadioListTile<PaymentTypeDelivery>(
  //   activeColor: theme.primaryColor,
  //   title: Text(context.l10n.),
  //   value: PaymentTypeDelivery.card,
  //   groupValue: _paymentType,
  //   onChanged: (PaymentTypeDelivery? value) {
  //     setState(() {
  //       _paymentType = value!;
  //     });
  //   },
  // ),
  // RadioListTile<PaymentTypeDelivery>(
  //   activeColor: theme.primaryColor,
  //   title: Text(context.l10n.onlinePayment),
  //   value: PaymentTypeDelivery.online,
  //   groupValue: _paymentType,
  //   onChanged: (PaymentTypeDelivery? value) {
  //     setState(() {
  //       _paymentType = value!;
  //     });
  //   },
  // ),