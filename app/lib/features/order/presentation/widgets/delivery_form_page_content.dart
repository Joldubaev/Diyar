import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет с контентом страницы формы доставки
class DeliveryFormPageContent extends StatefulWidget {
  final List<CartItemEntity> cart;
  final int dishCount;
  final int totalPrice;
  final double deliveryPrice;
  final String? address;
  final String? initialUserName;
  final String? initialUserPhone;

  const DeliveryFormPageContent({
    super.key,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
    required this.deliveryPrice,
    this.address,
    this.initialUserName,
    this.initialUserPhone,
  });

  @override
  State<DeliveryFormPageContent> createState() => _DeliveryFormPageContentState();
}

class _DeliveryFormPageContentState extends State<DeliveryFormPageContent> {
  final _formKey = GlobalKey<FormState>();
  late final DeliveryFormControllers _controllers;

  @override
  void initState() {
    super.initState();

    // Парсим адрес (если передан) - это ответственность UI, не Cubit
    final parsedAddress = DeliveryAddressParser.parseAddress(widget.address);

    // UI сам инициализирует контроллеры из параметров навигации
    // Cubit ничего не знает про initial-данные
    _controllers = DeliveryFormControllers(
      initialPhone: widget.initialUserPhone ?? '+996',
      initialUserName: widget.initialUserName,
      initialAddress: parsedAddress.address,
      initialHouseNumber: parsedAddress.houseNumber,
    );
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  /// Тупой метод - только валидация формы и вызов Cubit
  void _onSubmit() {
    // Валидация формы (UI-валидация, не бизнес-логика)
    if (!_formKey.currentState!.validate()) return;

    // Вызываем Cubit для бизнес-валидации и обработки
    context.read<DeliveryFormCubit>().validateAndPrepareOrder(
          subtotalPrice: widget.totalPrice,
          deliveryPrice: widget.deliveryPrice,
          onSuccess: () {
            final state = context.read<DeliveryFormCubit>().state;
            if (state is DeliveryFormLoaded) {
              DeliveryOrderConfirmationHelper.showOrderConfirmationSheet(
                context: context,
                state: state,
                cart: widget.cart,
                dishCount: widget.dishCount,
                totalPrice: widget.totalPrice,
                deliveryPrice: widget.deliveryPrice,
                controllers: _controllers,
              );
            }
          },
          onError: (errorMessage) {
            showToast(errorMessage, isError: true);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DeliveryFormListenerWidget(
      controllers: _controllers,
      child: BlocBuilder<DeliveryFormCubit, DeliveryFormState>(
        builder: (context, state) {
          if (state is! DeliveryFormLoaded) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.colorScheme.primary,
              title: Text(
                context.l10n.orderDetails,
                style: theme.textTheme.titleSmall!.copyWith(
                  color: theme.colorScheme.onTertiaryFixed,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: theme.colorScheme.onTertiaryFixed,
                ),
                onPressed: () => context.router.maybePop(),
              ),
            ),
            body: DeliveryFormWidget(
              paymentType: state.paymentType,
              onPaymentTypeChanged: (PaymentTypeDelivery type) {
                context.read<DeliveryFormCubit>().changePaymentType(type);
              },
              formKey: _formKey,
              theme: theme,
              userName: _controllers.userName,
              phoneController: _controllers.phoneController,
              addressController: _controllers.addressController,
              houseController: _controllers.houseController,
              entranceController: _controllers.entranceController,
              floorController: _controllers.floorController,
              apartmentController: _controllers.apartmentController,
              intercomController: _controllers.intercomController,
              sdachaController: _controllers.sdachaController,
              commentController: _controllers.commentController,
              totalOrderCost: state.totalOrderCost,
              onChangeAmountSelected: (result) {
                context.read<DeliveryFormCubit>().setChangeAmountResult(result);
              },
              onConfirm: _onSubmit,
            ),
          );
        },
      ),
    );
  }
}
