import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/order/presentation/widgets/custom_dialog_widget.dart';
import 'package:diyar/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class DeliveryFormPage extends StatefulWidget {
  final List<CartItemModel> cart;
  final int totalPrice;
  final int dishCount;
  const DeliveryFormPage(
      {super.key,
      required this.cart,
      required this.dishCount,
      required this.totalPrice});

  @override
  State<DeliveryFormPage> createState() => _DeliveryFormPageState();
}

class _DeliveryFormPageState extends State<DeliveryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '+996');
  final _addressController = TextEditingController();
  final _houseController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _intercomController = TextEditingController();
  final _floorController = TextEditingController();
  final _entranceController = TextEditingController();
  final _commentController = TextEditingController();
  final _userName = TextEditingController();
  final _sdachaController = TextEditingController();

  final PaymentTypeDelivery _paymentType = PaymentTypeDelivery.cash;
  UserModel? user;

  @override
  void initState() {
    context.read<ProfileCubit>().getUser();
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileGetLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProfileGetLoaded) {
          user = state.userModel;
          _userName.text = user?.name ?? '';
          _phoneController.text = user?.phone ?? '+996';
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
                              .copyWith(color: theme.colorScheme.onSurface)),
                      content: Text(context.l10n.operatorContact,
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: theme.colorScheme.onSurface),
                          maxLines: 2),
                      actions: [
                        SubmitButtonWidget(
                          textStyle: theme.textTheme.bodyMedium!
                              .copyWith(color: theme.colorScheme.onPrimary),
                          title: context.l10n.ok,
                          bgColor: AppColors.green,
                          onTap: () {
                            context.router.pushAndPopUntil(
                              const MainRoute(),
                              predicate: (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is CreateOrderError) {
              showToast(context.l10n.someThingIsWrong, isError: true);
            }
          },
          builder: (context, state) {
            var deliveryPrice = context.read<OrderCubit>().deliveryPrice;
            final totalOrderCost = widget.totalPrice + deliveryPrice;
            if (deliveryPrice == 0) {
              deliveryPrice = 550;
            }
            if (!context.read<OrderCubit>().isAddressSearch) {
              _addressController.text = context.read<OrderCubit>().address;
            }
            log(_addressController.text);
            _extractHouseNumberFromAddress();

            return Scaffold(
              appBar: AppBar(
                backgroundColor: theme.colorScheme.primary,
                title: Text(context.l10n.orderDetails,
                    style: theme.textTheme.titleSmall!
                        .copyWith(color: theme.colorScheme.onTertiaryFixed)),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_sharp,
                      color: theme.colorScheme.onTertiaryFixed),
                  onPressed: () {
                    context.router.maybePop();
                  },
                ),
              ),
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
                        }),
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
                      inputType: TextInputType.text,
                      hintText: context.l10n.adress,
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
                    const SizedBox(height: 10),
                    CustomInputWidget(
                        titleColor: theme.colorScheme.onSurface,
                        filledColor: theme.colorScheme.surface,
                        inputType: TextInputType.text,
                        controller: _houseController,
                        hintText: context.l10n.houseNumber,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return context.l10n.pleaseEnterHouseNumber;
                          }
                          return null;
                        }),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomInputWidget(
                            titleColor: theme.colorScheme.onSurface,
                            filledColor: theme.colorScheme.surface,
                            inputType: TextInputType.text,
                            controller: _entranceController,
                            hintText: 'Подъезд',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomInputWidget(
                            titleColor: theme.colorScheme.onSurface,
                            filledColor: theme.colorScheme.surface,
                            inputType: TextInputType.text,
                            controller: _floorController,
                            hintText: context.l10n.floor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomInputWidget(
                            titleColor: theme.colorScheme.onSurface,
                            filledColor: theme.colorScheme.surface,
                            inputType: TextInputType.text,
                            controller: _apartmentController,
                            hintText: context.l10n.ofice,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomInputWidget(
                            titleColor: theme.colorScheme.onSurface,
                            filledColor: theme.colorScheme.surface,
                            inputType: TextInputType.text,
                            controller: _intercomController,
                            hintText: context.l10n.codeIntercom,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomInputWidget(
                      titleColor: theme.colorScheme.onSurface,
                      filledColor: theme.colorScheme.surface,
                      inputType: TextInputType.number,
                      controller: _sdachaController,
                      hintText: context.l10n.change,
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
                    CustomInputWidget(
                        titleColor: theme.colorScheme.onSurface,
                        filledColor: theme.colorScheme.surface,
                        controller: _commentController,
                        hintText: context.l10n.comment,
                        validator: (val) => null,
                        maxLines: 3),
                    const SizedBox(height: 20),
                    Card(
                      color: theme.colorScheme.primary,
                      child: ListTile(
                          title: Text('Сумма заказа $totalOrderCost сом',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onTertiaryFixed,
                                  fontWeight: FontWeight.w500)),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: theme.colorScheme.onTertiaryFixed),
                          onTap: _onSubmit),
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

  void _onSubmit() {
    final theme = Theme.of(context);
    log(context.read<CartCubit>().totalPrice.toString());

    if (_formKey.currentState!.validate()) {
      var deliveryPrice = context.read<OrderCubit>().deliveryPrice;
      if (deliveryPrice == 0) {
        deliveryPrice = 550;
      }

      final totalOrderCost = widget.totalPrice + deliveryPrice;
      final sdacha = int.tryParse(_sdachaController.text) ?? 0;

      if (sdacha < totalOrderCost) {
        showToast('Сдача должна быть больше или равна общей стоимости заказа',
            isError: true);
        return;
      }

      showModalBottomSheet(
        context: context,
        backgroundColor: theme.colorScheme.surface,
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
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.orderConfirmation,
                          style: theme.textTheme.bodyLarge!
                              .copyWith(color: theme.colorScheme.onSurface),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => context.maybePop(),
                        ),
                      ],
                    ),
                    CustomDialogWidget(
                      title: context.l10n.orderAmount,
                      description: '${widget.totalPrice} сом',
                    ),
                    CustomDialogWidget(
                      title: context.l10n.deliveryCost,
                      description: '$deliveryPrice сом',
                    ),
                    const Divider(),
                    CustomDialogWidget(
                      title: context.l10n.total,
                      description: '$totalOrderCost сом',
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, state) {
                        return SubmitButtonWidget(
                          textStyle: theme.textTheme.bodyMedium!
                              .copyWith(color: theme.colorScheme.onPrimary),
                          title: context.l10n.confirm,
                          bgColor: AppColors.green,
                          isLoading: state is CreateOrderLoading,
                          onTap: () {
                            context
                                .read<OrderCubit>()
                                .createOrder(CreateOrderModel(
                                  userPhone: _phoneController.text,
                                  userName: _userName.text,
                                  address: _addressController.text,
                                  comment: _commentController.text,
                                  price: widget.totalPrice,
                                  deliveryPrice: deliveryPrice,
                                  houseNumber: _houseController.text,
                                  kvOffice: _apartmentController.text,
                                  intercom: _intercomController.text,
                                  floor: _floorController.text,
                                  entrance: _entranceController.text,
                                  paymentMethod: _paymentType.name,
                                  dishesCount: widget.dishCount,
                                  sdacha: sdacha,
                                  foods: widget.cart
                                      .map((e) => OrderFoodItem(
                                            name: e.food?.name ?? '',
                                            price: e.food?.price ?? 0,
                                            quantity: e.quantity ?? 1,
                                          ))
                                      .toList(),
                                ))
                                .then((value) {
                              context.read<CartCubit>().clearCart();
                              context.read<CartCubit>().dishCount = 0;
                            });
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

  void _extractHouseNumberFromAddress() {
    final addressParts = _addressController.text.split(', ');
    if (addressParts.isNotEmpty) {
      _houseController.text = addressParts.last;
    }
  }
}

enum PaymentTypeDelivery { cash, card, online }
