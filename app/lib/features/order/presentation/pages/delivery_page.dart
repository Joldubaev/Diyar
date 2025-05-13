import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/features/profile/prof.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DeliveryFormPage extends StatefulWidget {
  final List<CartItemEntity> cart;
  final int totalPrice;
  final int dishCount;
  final String? address;
  final double deliveryPrice;

  const DeliveryFormPage({
    super.key,
    this.address,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
    required this.deliveryPrice,
  });
  @override
  State<DeliveryFormPage> createState() => _DeliveryFormPageState();
}

class _DeliveryFormPageState extends State<DeliveryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      final parts = widget.address!.split(', ');
      if (parts.isNotEmpty) {
        _addressController.text = parts[0];
        if (parts.length > 1) {
          _houseController.text = parts.sublist(1).join(', ');
        }
      } else {
        _addressController.text = widget.address!;
      }
    }
    context.read<ProfileCubit>().getUser();

    if (_phoneController.text.isEmpty) {
      _phoneController.text = '+996';
    }
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
    _sdachaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, profileState) {
        if (profileState is ProfileGetLoaded) {
          if (_userName.text.isEmpty) {
            _userName.text = profileState.userModel.userName ?? '';
          }
          if (_phoneController.text.isEmpty || _phoneController.text == '+996') {
            _phoneController.text = profileState.userModel.phone;
          }
        }
      },
      child: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, orderState) {
          if (orderState is CreateOrderLoaded) {
            context.read<CartBloc>().add(ClearCart());
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
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
                          Navigator.of(dialogContext).pop();
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
          } else if (orderState is CreateOrderError) {
            showToast(orderState.message.isNotEmpty ? orderState.message : context.l10n.someThingIsWrong,
                isError: true);
          }
        },
        builder: (context, orderState) {
          final totalOrderCost = widget.totalPrice + widget.deliveryPrice.toInt();

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
              onConfirm: () => _onSubmit(widget.deliveryPrice.toInt(), totalOrderCost),
            ),
          );
        },
      ),
    );
  }

  void _onSubmit(int calculatedDeliveryPrice, int calculatedTotalOrderCost) {
    final theme = Theme.of(context);

    if (_formKey.currentState!.validate()) {
      final sdachaValue = int.tryParse(_sdachaController.text) ?? 0;
      int sdachaToSend = 0;
      if (sdachaValue != 0) {
        if (sdachaValue < calculatedTotalOrderCost) {
          showToast("Change cannot be less than the total order amount", isError: true);
          return;
        }
        sdachaToSend = sdachaValue;
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
        builder: (bottomSheetContext) {
          return CustomBottomSheet(
            region: '',
            theme: theme,
            widget: widget,
            deliveryPrice: calculatedDeliveryPrice,
            totalOrderCost: calculatedTotalOrderCost,
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
            sdacha: sdachaToSend,
          );
        },
      );
    }
  }
}
