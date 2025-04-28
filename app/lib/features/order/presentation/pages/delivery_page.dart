import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/profile/prof.dart';
import 'package:diyar/l10n/l10n.dart';
import '../../data/models/distric_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DeliveryFormPage extends StatefulWidget {
  final List<CartItemEntity> cart;
  final int totalPrice;
  final int dishCount;
  final DistricModel? distric;
  final String? address;

  const DeliveryFormPage({
    super.key,
    this.distric,
    this.address,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
  });
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
    _addressController.text = widget.address ?? '';
    log('Address: ${widget.address}');
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
          _userName.text = user?.userName ?? '';
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
                          style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface)),
                      content: Text(context.l10n.operatorContact,
                          style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurface), maxLines: 2),
                      actions: [
                        SubmitButtonWidget(
                          textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary),
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

            final totalOrderCost =
                widget.distric != null ? widget.distric!.price! + widget.totalPrice : widget.totalPrice + deliveryPrice;
            if (deliveryPrice == 0) {
              deliveryPrice = 550;
            }
            if (widget.address != null) {
              _addressController.text = widget.address!;
            } else if (!context.read<OrderCubit>().isAddressSearch) {
              _addressController.text = context.read<OrderCubit>().address;
            }
            log(_addressController.text);
            _extractHouseNumberFromAddress();

            return Scaffold(
              appBar: AppBar(
                backgroundColor: theme.colorScheme.primary,
                title: Text(context.l10n.orderDetails,
                    style: theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.onTertiaryFixed)),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_sharp, color: theme.colorScheme.onTertiaryFixed),
                  onPressed: () {
                    context.router.maybePop();
                  },
                ),
              ),
              body: DeliveryFormWidget(
                formKey: _formKey,
                theme: theme,
                userName: _userName,
                phoneController: _phoneController,
                addressController: _addressController,
                houseController: _houseController,
                entranceController: _entranceController,
                floorController: _floorController,
                apartmentController: _apartmentController,
                intercomController: _intercomController,
                sdachaController: _sdachaController,
                commentController: _commentController,
                totalOrderCost: totalOrderCost,
                onConfirm: () => _onSubmit(),
              ),
            );
          },
        );
      },
    );
  }

  void _onSubmit() {
    final theme = Theme.of(context);

    // Get total price from CartBloc state
    double cartBlocTotalPrice = 0.0;
    final cartState = context.read<CartBloc>().state;
    if (cartState is CartLoaded) {
      cartBlocTotalPrice = cartState.totalPrice;
    } else {
      log("Warning: Cart state is not CartLoaded in _onSubmit");
      // Handle error or use a default? For logging, maybe 0 is ok.
    }
    log("CartBloc Total Price (for logging): ${cartBlocTotalPrice.toString()}");

    if (_formKey.currentState!.validate()) {
      var deliveryPrice = context.read<OrderCubit>().deliveryPrice;
      var districtPrice = widget.distric?.price ?? 0;

      // 🔥 Устанавливаем правильную цену доставки
      if (deliveryPrice == 0 && districtPrice == 0) {
        deliveryPrice = 550; // Если нигде нет цены, ставим 550
      } else {
        deliveryPrice = deliveryPrice != 0 ? deliveryPrice : districtPrice;
      }
      log('Delivery Price: $deliveryPrice');

      final totalOrderCost = widget.totalPrice + deliveryPrice;
      final sdachaValue = int.tryParse(_sdachaController.text) ?? 0;
      final calculatedSdacha = sdachaValue != 0 ? sdachaValue : deliveryPrice;

      log('Total Order Cost: $totalOrderCost');
      log('Sdacha: $calculatedSdacha');

      if (calculatedSdacha < totalOrderCost) {
        showToast('Сдача должна быть больше или равна общей стоимости заказа', isError: true);
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
          return CustomBottomSheet(
            region: widget.distric?.name ?? '',
            theme: theme,
            widget: widget,
            deliveryPrice: deliveryPrice,
            totalOrderCost: totalOrderCost,
            phoneController: _phoneController,
            userName: _userName,
            addressController: _addressController,
            commentController: _commentController,
            houseController: _houseController,
            apartmentController: _apartmentController,
            intercomController: _intercomController,
            floorController: _floorController,
            entranceController: _entranceController,
            paymentType: _paymentType,
            sdacha: calculatedSdacha,
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
