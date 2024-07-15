import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
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
    final theme = Theme.of(context);
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is CreateOrderLoaded) {
          context.router
              .pushAndPopUntil(const MainRoute(), predicate: (_) => false);
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
            child: Text(context.l10n.someThingIsWrong,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: theme.colorScheme.error)),
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
                filledColor: theme.colorScheme.surface,
                inputType: TextInputType.text,
                hintText: context.l10n.enterAddress,
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
                  filledColor: theme.colorScheme.surface,
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
                  filledColor: theme.colorScheme.surface,
                  inputType: TextInputType.text,
                  controller: _apartmentController,
                  hintText: '',
                  title: context.l10n.ofice),
              Row(children: [
                Expanded(
                    child: CustomInputWidget(
                        filledColor: theme.colorScheme.surface,
                        inputType: TextInputType.number,
                        controller: _floorController,
                        hintText: '',
                        title: context.l10n.floor)),
                const SizedBox(width: 10),
                Expanded(
                    child: CustomInputWidget(
                        filledColor: theme.colorScheme.surface,
                        inputType: TextInputType.number,
                        controller: _intercomController,
                        hintText: '',
                        title: context.l10n.entranceNumber))
              ]),
              CustomInputWidget(
                  filledColor: theme.colorScheme.surface,
                  controller: _commentController,
                  hintText: '',
                  title: context.l10n.comment),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: PopupMenuButton<String>(
                  onSelected: (String value) {
                    log('Selected: $value');
                    setState(() {
                      if (value == context.l10n.payWithCash) {
                        _paymentType = PaymentTypeDelivery.cash;
                      } else if (value == context.l10n.payWithCard) {
                        _paymentType = PaymentTypeDelivery.card;
                      } else if (value == context.l10n.payOnline) {
                        _paymentType = PaymentTypeDelivery.online;
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      context.l10n.payWithCash,
                      // 'Оплатить картой',
                      // 'Оплатить онлайн'
                    ].map((String choice) {
                      return PopupMenuItem<String>(
                          value: choice, child: Text(choice));
                    }).toList();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Icon(Icons.payment)),
                      Text(context.l10n.payWithCash),
                    ],
                  ),
                ),
              ),
              CustomInputWidget(
                filledColor: theme.colorScheme.surface,
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
                bgColor: Theme.of(context).primaryColor,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: theme.colorScheme.surface),
                onTap: () {
                  log(context.read<CartCubit>().totalPrice.toString());
                  if (_formKey.currentState!.validate()) {
                    var deliveryPrice =
                        context.read<OrderCubit>().deliveryPrice;
                    if (deliveryPrice == 0) {
                      deliveryPrice = 550;
                    }
                  }
                  showBottomSheet(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.35,
          minChildSize: 0.35,
          expand: false,
          maxChildSize: 0.35,
          builder: (BuildContext context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.orderConfirmation,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  CustomDialogWidget(
                      title: context.l10n.orderAmount,
                      description:
                          '${context.read<CartCubit>().totalPrice} сом'),
                  CustomDialogWidget(
                      title: context.l10n.deliveryCost,
                      description:
                          '${context.read<OrderCubit>().deliveryPrice} сом'),
                  const Divider(),
                  CustomDialogWidget(
                      title: context.l10n.total,
                      description:
                          '${context.read<CartCubit>().totalPrice + context.read<OrderCubit>().deliveryPrice} сом'),
                  CustomButton(
                    title: context.l10n.confirm,
                    bgColor: AppColors.green,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(context.l10n.yourOrdersConfirm,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface)),
                            content: Text(context.l10n.operatorContact,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                maxLines: 2),
                            actions: [
                              CustomButton(
                                title: context.l10n.ok,
                                bgColor: AppColors.green,
                                onTap: () {
                                  context
                                      .read<OrderCubit>()
                                      .createOrder(CreateOrderModel(
                                          userPhone: _phoneController.text,
                                          userName: _userName.text,
                                          address: _addressController.text,
                                          comment: _commentController.text,
                                          price: context
                                              .read<CartCubit>()
                                              .totalPrice,
                                          deliveryPrice: context
                                              .read<OrderCubit>()
                                              .deliveryPrice,
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
                                              .toList()))
                                      .then((value) {
                                    context.read<CartCubit>().clearCart();
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
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

enum PaymentTypeDelivery { cash, card, online }
