import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/order/presentation/widgets/adress_section_widget.dart';
import 'package:diyar/features/order/presentation/widgets/bonus_and_total_section.dart';
import 'package:diyar/features/order/presentation/widgets/change_amoun_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет с контентом страницы формы доставки
/// Адаптирован для работы с текущей логикой (без ChangeAmountResult, без validateAndPrepareOrder)
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
    _controllers = DeliveryFormControllers(
      initialPhone: widget.initialUserPhone ?? '+996',
      initialUserName: widget.initialUserName,
      initialAddress: parsedAddress.address,
      initialHouseNumber: parsedAddress.houseNumber,
    );
    
    // Синхронизируем извлеченный номер дома с state кубита
    if (parsedAddress.houseNumber != null && parsedAddress.houseNumber!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<DeliveryFormCubit>().updateField(houseNumber: parsedAddress.houseNumber);
        }
      });
    }

    context.read<ProfileCubit>().getUser();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  /// Показывает bottom sheet для подтверждения заказа (адаптированная логика)
  void _showOrderConfirmationBottomSheet(BuildContext context, DeliveryFormLoaded state) {
    // Проверяем сдачу при наличной оплате
    if (state.paymentType == PaymentTypeDelivery.cash) {
      if (state.changeAmount == null) {
        showToast('Пожалуйста, введите сумму с которой нужна сдача', isError: true);
        return;
      }
      // Сравниваем с полной суммой БЕЗ вычета бонусов
      final fullOrderPrice = state.subtotalPrice + state.deliveryPrice.toInt();
      if (state.changeAmount! < fullOrderPrice) {
        showToast('Сумма должна быть не меньше $fullOrderPrice сом', isError: true);
        return;
      }
    }

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

  @override
  Widget build(BuildContext context) {
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
            appBar: CustomAppBar(title: context.l10n.orderDetails),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AddressSection(controllers: _controllers, formKey: _formKey),
                  const SizedBox(height: 10),
                  ChangeAmountSection(controllers: _controllers),
                  const SizedBox(height: 10),
                  BonusAndTotalSection(
                    controllers: _controllers,
                    totalPrice: widget.totalPrice,
                    deliveryPrice: widget.deliveryPrice,
                  ),
                  const SizedBox(height: 10),
                  CustomInputWidget(
                    titleColor: Theme.of(context).colorScheme.onSurface,
                    filledColor: Theme.of(context).colorScheme.surface,
                    controller: _controllers.commentController,
                    hintText: context.l10n.comment,
                    validator: (val) => null,
                    maxLines: 3,
                    onChanged: (value) {
                      context.read<DeliveryFormCubit>().updateField(comment: value);
                    },
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Theme.of(context).colorScheme.primary,
                    child: ListTile(
                      title: Text(
                        'Сумма заказа ${state.totalOrderCost} сом',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onTertiaryFixed,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.onTertiaryFixed,
                      ),
                      onTap: () => _showOrderConfirmationBottomSheet(context, state),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
