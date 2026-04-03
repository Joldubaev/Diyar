import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/ordering/delivery/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/ordering/delivery/presentation/widgets/address_section_widget.dart';
import 'package:diyar/features/ordering/delivery/presentation/widgets/bonus_and_total_section.dart';
import 'package:diyar/features/ordering/delivery/presentation/widgets/change_amount_section.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore_for_file: deprecated_member_use
// RegExp нужен для firstMatch и групп захвата при извлечении номера дома

@RoutePage()
class DeliveryFormPage extends StatelessWidget {
  final List<CartItemEntity> cart;
  final int totalPrice;
  final int dishCount;
  final String? address;
  final double deliveryPrice;
  final String? initialUserName;
  final String? initialUserPhone;
  final String? initialEntrance;
  final String? initialFloor;
  final String? initialApartment;
  final String? initialIntercom;
  final String? initialComment;

  const DeliveryFormPage({
    super.key,
    this.address,
    this.initialUserName,
    this.initialUserPhone,
    this.initialEntrance,
    this.initialFloor,
    this.initialApartment,
    this.initialIntercom,
    this.initialComment,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
    required this.deliveryPrice,
  });

  /// Извлекает номер дома из адреса вида "проспект Чуй, д. 1"
  static String? _extractHouseNumber(String? address) {
    if (address == null || address.isEmpty) return null;

    // Паттерны для поиска номера дома: ", д. 1", ", д.1", ",д. 1", ",д.1"
    final regex = RegExp(r',\s*д\.\s*(\d+)', caseSensitive: false);
    final match = regex.firstMatch(address);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final extractedHouseNumber = _extractHouseNumber(address);
    return BlocProvider(
      create: (context) => di.sl<DeliveryFormCubit>()
        ..initialize(
          subtotalPrice: totalPrice,
          deliveryPrice: deliveryPrice,
          rawAddress: address,
          initialUserName: initialUserName,
          initialUserPhone: initialUserPhone,
          initialHouseNumber: extractedHouseNumber,
          initialEntrance: initialEntrance,
          initialFloor: initialFloor,
          initialApartment: initialApartment,
          initialIntercom: initialIntercom,
          initialComment: initialComment,
        ),
      child: DeliveryFormView(
        cart: cart,
        dishCount: dishCount,
        totalPrice: totalPrice,
        deliveryPrice: deliveryPrice,
        address: address,
        initialUserName: initialUserName,
        initialUserPhone: initialUserPhone,
        initialEntrance: initialEntrance,
        initialFloor: initialFloor,
        initialApartment: initialApartment,
        initialIntercom: initialIntercom,
        initialComment: initialComment,
      ),
    );
  }
}

class DeliveryFormView extends StatefulWidget {
  final List<CartItemEntity> cart;
  final int dishCount;
  final int totalPrice;
  final double deliveryPrice;
  final String? address;
  final String? initialUserName;
  final String? initialUserPhone;
  final String? initialEntrance;
  final String? initialFloor;
  final String? initialApartment;
  final String? initialIntercom;
  final String? initialComment;

  const DeliveryFormView({
    super.key,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
    required this.deliveryPrice,
    this.address,
    this.initialUserName,
    this.initialUserPhone,
    this.initialEntrance,
    this.initialFloor,
    this.initialApartment,
    this.initialIntercom,
    this.initialComment,
  });

  @override
  State<DeliveryFormView> createState() => _DeliveryFormViewState();
}

class _DeliveryFormViewState extends State<DeliveryFormView> {
  late final DeliveryFormControllers _controllers;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final extractedHouseNumber = DeliveryFormPage._extractHouseNumber(widget.address);
    _controllers = DeliveryFormControllers(
      initialPhone: widget.initialUserPhone,
      initialUserName: widget.initialUserName,
      initialAddress: widget.address,
      initialHouseNumber: extractedHouseNumber,
      initialEntrance: widget.initialEntrance,
      initialFloor: widget.initialFloor,
      initialApartment: widget.initialApartment,
      initialIntercom: widget.initialIntercom,
      initialComment: widget.initialComment,
    );

    // Синхронизируем извлеченный номер дома с state кубита
    if (extractedHouseNumber != null && extractedHouseNumber.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<DeliveryFormCubit>().updateField(houseNumber: extractedHouseNumber);
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

  void _showOrderConfirmationBottomSheet(BuildContext context, DeliveryFormLoaded state) {
    if (state.paymentType == PaymentTypeDelivery.cash) {
      if (state.changeAmount == null) {
        showToast('Пожалуйста, введите сумму с которой нужна сдача', isError: true);
        return;
      }
      // Как в CreateOrderUseCase: сравнение с полной суммой без вычета бонусов (order.price).
      final fullOrderPrice = state.subtotalPrice + state.deliveryPrice.toInt();
      if (state.changeAmount! < fullOrderPrice) {
        showToast('Сумма должна быть не меньше $fullOrderPrice сом', isError: true);
        return;
      }
    }

    final deliveryFormCubit = context.read<DeliveryFormCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: deliveryFormCubit),
          BlocProvider(create: (_) => di.sl<TemplatesListCubit>()),
        ],
        child: CustomBottomSheet(
          cart: widget.cart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => current is ProfileGetLoaded,
      listener: (context, profileState) {
        if (profileState is! ProfileGetLoaded) return;
        final user = profileState.userModel;
        final deliveryState = context.read<DeliveryFormCubit>().state;
        if (deliveryState is! DeliveryFormLoaded) return;
        final needFillName = deliveryState.userName.isEmpty && (user.userName ?? '').isNotEmpty;
        final needFillPhone =
            (deliveryState.userPhone.isEmpty || deliveryState.userPhone == '+996') && (user.phone ?? '').isNotEmpty;
        if (needFillName || needFillPhone) {
          if (needFillName && (user.userName ?? '').isNotEmpty) {
            _controllers.userName.text = user.userName!;
          }
          if (needFillPhone && (user.phone ?? '').isNotEmpty) {
            _controllers.phoneController.text = user.phone!;
          }
          context.read<DeliveryFormCubit>().updateField(
                userName: user.userName ?? deliveryState.userName,
                userPhone: user.phone ?? deliveryState.userPhone,
              );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.orderDetails),
        body: BlocBuilder<DeliveryFormCubit, DeliveryFormState>(
          builder: (context, state) {
            if (state is! DeliveryFormLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AddressSection(
                    controllers: _controllers,
                    formKey: formKey,
                    paymentType: state.paymentType,
                    onPaymentTypeChanged: (v) => context.read<DeliveryFormCubit>().setPaymentType(v),
                  ),
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
            );
          },
        ),
      ),
    );
  }
}
