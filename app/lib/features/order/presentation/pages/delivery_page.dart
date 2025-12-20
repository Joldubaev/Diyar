import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DeliveryFormPage extends StatelessWidget {
  final List<CartItemEntity> cart;
  final int totalPrice;
  final int dishCount;
  final String? address;
  final double deliveryPrice;
  final String? initialUserName;
  final String? initialUserPhone;

  const DeliveryFormPage({
    super.key,
    this.address,
    this.initialUserName,
    this.initialUserPhone,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
    required this.deliveryPrice,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di.sl<DeliveryFormCubit>();
        cubit.initialize(
          subtotalPrice: totalPrice,
          deliveryPrice: deliveryPrice,
        );
        return cubit;
      },
      child: _DeliveryFormPageContent(
        cart: cart,
        dishCount: dishCount,
        totalPrice: totalPrice,
        deliveryPrice: deliveryPrice,
        address: address,
        initialUserName: initialUserName,
        initialUserPhone: initialUserPhone,
      ),
    );
  }
}

class _DeliveryFormPageContent extends StatefulWidget {
  final List<CartItemEntity> cart;
  final int dishCount;
  final int totalPrice;
  final double deliveryPrice;
  final String? address;
  final String? initialUserName;
  final String? initialUserPhone;

  const _DeliveryFormPageContent({
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
    required this.deliveryPrice,
    this.address,
    this.initialUserName,
    this.initialUserPhone,
  });

  @override
  State<_DeliveryFormPageContent> createState() => _DeliveryFormPageContentState();
}

class _DeliveryFormPageContentState extends State<_DeliveryFormPageContent> {
  final _formKey = GlobalKey<FormState>();
  late final DeliveryFormControllers _controllers;

  @override
  void initState() {
    super.initState();

    // Парсим адрес (если передан) - это ответственность UI, не Cubit
    String? parsedAddress;
    String? parsedHouseNumber;
    if (widget.address != null) {
      final parts = widget.address!.split(', ');
      if (parts.isNotEmpty) {
        parsedAddress = parts[0];
        if (parts.length > 1) {
          parsedHouseNumber = parts.sublist(1).join(', ');
        }
      } else {
        parsedAddress = widget.address;
      }
    }

    // UI сам инициализирует контроллеры из параметров навигации
    // Cubit ничего не знает про initial-данные
    _controllers = DeliveryFormControllers(
      initialPhone: widget.initialUserPhone ?? '+996',
      initialUserName: widget.initialUserName,
      initialAddress: parsedAddress,
      initialHouseNumber: parsedHouseNumber,
    );
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  /// Побочный эффект: показ bottom sheet для подтверждения заказа
  /// UI сам вычисляет данные для подтверждения на основе состояния
  void _showOrderConfirmationSheet(BuildContext context, DeliveryFormLoaded state) {
    // UI сам вычисляет данные для подтверждения (ослабленная связь с Cubit)
    final sdachaValue = state.changeAmountResult?.toChangeAmount() ?? 0;

    showModalBottomSheet(
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
      builder: (bottomSheetContext) {
        return CustomBottomSheet(
          dishCount: widget.dishCount,
          region: '',
          theme: Theme.of(context),
          widget: DeliveryFormPage(
            cart: widget.cart,
            dishCount: widget.dishCount,
            totalPrice: widget.totalPrice,
            deliveryPrice: widget.deliveryPrice,
          ),
          deliveryPrice: widget.deliveryPrice.toInt(),
          totalOrderCost: state.totalOrderCost,
          phoneController: _controllers.phoneController,
          userName: _controllers.userName,
          addressController: _controllers.addressController,
          commentController: _controllers.commentController,
          houseController: _controllers.houseController,
          apartmentController: _controllers.apartmentController,
          intercomController: _controllers.intercomController,
          floorController: _controllers.floorController,
          entranceController: _controllers.entranceController,
          paymentType: state.paymentType,
          sdacha: sdachaValue,
        );
      },
    );
  }

  /// Тупой метод - только валидация формы и вызов Cubit
  void _onSubmit() {
    // Валидация формы (UI-валидация, не бизнес-логика)
    if (!_formKey.currentState!.validate()) return;

    // Вызываем Cubit для бизнес-валидации и обработки
    context.read<DeliveryFormCubit>().validateAndPrepareOrder(
          subtotalPrice: widget.totalPrice,
          deliveryPrice: widget.deliveryPrice,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<DeliveryFormCubit, DeliveryFormState>(
      listenWhen: (previous, current) {
        if (current is! DeliveryFormLoaded) return false;
        if (previous is! DeliveryFormLoaded) return true;

        // Упрощенная логика: слушаем только важные изменения
        return current.validationError != previous.validationError ||
            current.confirmationRequestId != previous.confirmationRequestId ||
            current.changeAmountResult != previous.changeAmountResult ||
            current.paymentType != previous.paymentType;
      },
      listener: (context, state) {
        if (state is! DeliveryFormLoaded) return;

        // Показываем toast при ошибке валидации
        if (state.validationError != null) {
          showToast(state.validationError!, isError: true);
        }

        // Показываем bottom sheet при изменении confirmationRequestId
        // Monotonic token гарантирует одноразовость - не нужен ручной сброс
        if (state.confirmationRequestId > 0) {
          _showOrderConfirmationSheet(context, state);
        }

        // Обновление текста поля сдачи
        if (state.changeAmountResult != null) {
          _controllers.sdachaController.text = state.changeAmountResult!.getDisplayText(state.totalOrderCost);
        } else if (state.paymentType == PaymentTypeDelivery.online) {
          _controllers.sdachaController.clear();
        }
      },
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
                style: theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.onTertiaryFixed),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_sharp, color: theme.colorScheme.onTertiaryFixed),
                onPressed: () => context.router.maybePop(),
              ),
            ),
            body: DeliveryFormWidget(
              paymentType: state.paymentType,
              onPaymentTypeChanged: (type) {
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
