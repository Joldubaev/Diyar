import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_dialog_widget.dart';

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
        if (!context.read<OrderCubit>().isAddressSearch) {
          _addressController.text = context.read<OrderCubit>().address;
        }
        log(_addressController.text);
        List<String> parts = _addressController.text.split(',');
        String lastPart = parts.last.trim();
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
                inputType: TextInputType.text,
                hintText: 'Укажите ваш адрес',
                title: context.l10n.adress,
                controller: _addressController,
                isReadOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.l10n.pleaseEnterAddress;
                  } else if (value.length < 3) {
                    return context.l10n.pleaseEnterCorrectAddress;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 4),
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
              Row(
                children: [
                  Expanded(
                    child: CustomInputWidget(
                      inputType: TextInputType.number,
                      controller: _floorController,
                      hintText: '',
                      title: context.l10n.floor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomInputWidget(
                      inputType: TextInputType.number,
                      controller: _intercomController,
                      hintText: '',
                      title: context.l10n.entranceNumber,
                    ),
                  ),
                ],
              ),
              CustomInputWidget(
                controller: _commentController,
                hintText: '',
                title: context.l10n.comment,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: PopupMenuButton<String>(
                  onSelected: (String value) {
                    log('Selected: $value');
                    setState(() {
                      if (value == 'Оплатить наличными') {
                        _paymentType = PaymentTypeDelivery.cash;
                      } else if (value == 'Оплатить картой') {
                        _paymentType = PaymentTypeDelivery.card;
                      } else if (value == 'Оплатить онлайн') {
                        _paymentType = PaymentTypeDelivery.online;
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      'Оплатить наличными',
                    ].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Icon(Icons.payment),
                      ),
                      const Text('Оплатить наличными'),
                    ],
                  ),
                ),
              ),
              CustomInputWidget(
                controller: _sdachaController,
                hintText: '',
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
                  log(context.read<CartCubit>().totalPrice.toString());
                  if (_formKey.currentState!.validate()) {
                    final totalPrice = context.read<CartCubit>().totalPrice;
                    var deliveryPrice =
                        context.read<OrderCubit>().deliveryPrice;
                    if (deliveryPrice == 0) {
                      deliveryPrice = 550;
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Подтверждение заказа',
                            style: theme.textTheme.bodyLarge!
                                .copyWith(color: AppColors.black1),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDialogWidget(
                                  title: 'Сумма заказа:',
                                  description: '$totalPrice сом'),
                              CustomDialogWidget(
                                  title: 'Стоимость доставки:',
                                  description: '$deliveryPrice сом'),
                              const Divider(),
                              CustomDialogWidget(
                                  title: 'Итого:',
                                  description:
                                      '${totalPrice + deliveryPrice} сом'),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  title: 'Подтвердить',
                                  bgColor: AppColors.green,
                                  onTap: () {
                                    context
                                        .read<OrderCubit>()
                                        .createOrder(
                                          CreateOrderModel(
                                            userPhone: _phoneController.text,
                                            userName: _userName.text,
                                            address: _addressController.text,
                                            comment: _commentController.text,
                                            price: totalPrice,
                                            deliveryPrice: deliveryPrice,
                                            houseNumber: _houseController.text,
                                            kvOffice: _apartmentController.text,
                                            intercom: _intercomController.text,
                                            floor: _floorController.text,
                                            entrance: _entranceController.text,
                                            paymentMethod: _paymentType.name,
                                            dishesCount: context
                                                .read<CartCubit>()
                                                .dishCount,
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
                                ),
                                const SizedBox(width: 10),
                                CustomButton(
                                  title: 'Отменить',
                                  bgColor: AppColors.red,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            )
                          ],
                        );
                      },
                    );
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

enum PaymentTypeDelivery { cash, card, online }
