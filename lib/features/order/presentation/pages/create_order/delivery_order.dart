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
  final TextEditingController _phoneController = TextEditingController(text: '+996');
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
          showToast(context.l10n.orderIsFailed, isError: true);
        }
      },
      builder: (context, state) {
        _addressController.text = context.read<OrderCubit>().address;

        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              CustomInputWidget(
                hintText: context.l10n.name,
                title: context.l10n.yourName,
                controller: _userName,
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
              CustomInputWidget(
                trailing: TextButton(
                  onPressed: () => context.router.push(const OrderMapRoute()),
                  child: Text(context.l10n.chooseOnMap, style: theme.textTheme.bodyMedium!),
                ),
                hintText: '',
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
                hintText: '',
                title: context.l10n.houseNumber,
                controller: _houseController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.l10n.pleaseEnterHouseNumber;
                  } else if (value.isEmpty) {
                    return context.l10n.pleaseEnterCorrectHouseNumber;
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomInputWidget(
                      hintText: '',
                      title: context.l10n.ofice,
                      controller: _apartmentController,
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: CustomInputWidget(
                      hintText: '',
                      title: context.l10n.codeIntercom,
                      controller: _intercomController,
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomInputWidget(
                      hintText: '',
                      title: context.l10n.floor,
                      controller: _floorController,
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: CustomInputWidget(
                      hintText: '',
                      title: context.l10n.entranceNumber,
                      controller: _entranceController,
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              CustomInputWidget(
                hintText: '',
                title: context.l10n.comment,
                controller: _commentController,
              ),
              const SizedBox(height: 10),
              Text(context.l10n.paymentMethod, style: theme.textTheme.bodyMedium!),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    autofocus: true,
                    value: PaymentTypeDelivery.cash,
                    groupValue: _paymentType,
                    onChanged: (value) {
                      setState(() => _paymentType = value!);
                    },
                  ),
                  Text(context.l10n.cash),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    value: PaymentTypeDelivery.card,
                    groupValue: _paymentType,
                    onChanged: (value) {
                      setState(() => _paymentType = value!);
                    },
                  ),
                  Text(context.l10n.postTerminal)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    value: PaymentTypeDelivery.online,
                    groupValue: _paymentType,
                    onChanged: (value) {
                      setState(() => _paymentType = value!);
                    },
                  ),
                  Text(context.l10n.onlinePayment)
                ],
              ),
              const SizedBox(height: 10),
              CustomInputWidget(
                controller: _sdachaController,
                hintText: '',
                title: context.l10n.change,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.l10n.pleaseEnterChange;
                  } else if (value.isEmpty) {
                    return context.l10n.pleaseEnterCorrectChange;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SubmitButtonWidget(
                title: context.l10n.confirmOrder,
                bgColor: theme.primaryColor,
                isLoading: state is CreateOrderLoading,
                textStyle: theme.textTheme.bodyMedium!.copyWith(color: AppColors.white),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<OrderCubit>()
                        .createOrder(
                          CreateOrderModel(
                            address: _addressController.text,
                            kvOffice: _apartmentController.text,
                            comment: _commentController.text,
                            entrance: _entranceController.text,
                            floor: _floorController.text,
                            houseNumber: _houseController.text,
                            intercom: _intercomController.text,
                            paymentMethod: _paymentType.toString().split('.').last,
                            userPhone: _phoneController.text,
                            userName: _userName.text,
                            deliveryPrice: context.read<OrderCubit>().deliveryPrice.toInt(),
                            price: context.read<CartCubit>().totalPrice,
                            dishesCount: context.read<CartCubit>().dishCount,
                            sdacha: int.parse(_sdachaController.text),
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
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

enum PaymentTypeDelivery { cash, card, online }
