import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/features/order/presentation/widgets/save_template_dialog.dart';
import 'package:diyar/features/templates/presentation/cubit/templates_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'info_dialog_widget.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<CartItemEntity> cart;

  const CustomBottomSheet({
    super.key,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<DeliveryFormCubit, DeliveryFormState>(
      listener: (context, currentState) {
        if (currentState is DeliveryFormLoaded && currentState.successMessage != null) {
          if (currentState.paymentType == PaymentTypeDelivery.online) {
            context.router.push(
              PaymentsRoute(
                orderNumber: currentState.successMessage!,
                amount: currentState.totalOrderCost.toString(),
              ),
            );
            Navigator.of(context).pop();
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return PopScope(
                  canPop: false,
                  child: AlertDialog(
                    title: Text(
                      context.l10n.yourOrdersConfirm,
                      style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface),
                    ),
                    content: Text(
                      context.l10n.operatorContact,
                      style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurface),
                      maxLines: 2,
                    ),
                    actions: [
                      SubmitButtonWidget(
                        textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary),
                        title: context.l10n.ok,
                        bgColor: AppColors.green,
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pop();
                          context.router.pushAndPopUntil(
                            const MainHomeRoute(),
                            predicate: (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          context.read<CartBloc>().add(ClearCart());
        } else if (currentState is DeliveryFormLoaded && currentState.validationError != null) {
          showToast(currentState.validationError!, isError: true);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.35,
        maxChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) {
          return BlocBuilder<DeliveryFormCubit, DeliveryFormState>(
            builder: (context, currentState) {
              if (currentState is! DeliveryFormLoaded) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 15),
                      _buildDetails(context, currentState),
                      const Divider(),
                      _buildSaveTemplateButton(context, currentState),
                      const SizedBox(height: 12),
                      SubmitButtonWidget(
                        textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary),
                        title: context.l10n.confirm,
                        bgColor: AppColors.green,
                        isLoading: currentState.isSubmitting,
                        onTap: () => _onConfirmOrder(context, currentState),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.orderConfirmation,
          style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context, DeliveryFormLoaded state) {
    Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoDialogWidget(
          title: context.l10n.orderAmount,
          description: '${state.subtotalPrice} сом',
        ),
        InfoDialogWidget(
          title: context.l10n.deliveryCost,
          description: '${state.deliveryPrice.toInt()} сом',
        ),
        if (state.bonusAmount != null && state.bonusAmount! > 0)
          InfoDialogWidget(
            title: 'Будет списано бонусов',
            description: '${state.bonusAmount!.toStringAsFixed(0)} сом',
          ),
        InfoDialogWidget(
          title: 'Итого c учетом бонусов',
          description: '${state.totalOrderCost} сом',
        ),
      ],
    );
  }

  Widget _buildSaveTemplateButton(BuildContext context, DeliveryFormLoaded state) {
    final theme = Theme.of(context);
    return BlocListener<TemplatesListCubit, TemplatesListState>(
      listener: (context, templateState) {
        if (templateState is TemplateCreateSuccess) {
          showToast('Адрес успешно сохранен в шаблоны', isError: false);
        } else if (templateState is TemplateCreateFailure) {
          showToast(templateState.message, isError: true);
        }
      },
      child: BlocBuilder<TemplatesListCubit, TemplatesListState>(
        builder: (context, templateState) {
          final isLoading = templateState is TemplateCreateLoading;
          return OutlinedButton.icon(
            onPressed: isLoading ? null : () => _onSaveTemplate(context, state),
            icon: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Icon(
                    Icons.bookmark_outline,
                    color: theme.colorScheme.primary,
                  ),
            label: Text(
              'Сохранить адрес',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onSaveTemplate(BuildContext context, DeliveryFormLoaded state) async {
    final templatesCubit = context.read<TemplatesListCubit>();
    final theme = Theme.of(context);

    // Формируем название по умолчанию из адреса
    final defaultName = state.address.isNotEmpty ? state.address : 'Новый адрес';

    // Показываем диалог для ввода имени шаблона
    final templateName = await SaveTemplateDialog.show(
      context: context,
      defaultName: defaultName,
      theme: theme,
    );

    if (templateName == null || templateName.isEmpty) {
      return; // Пользователь отменил
    }

    // Создаем AddressEntity из state
    final addressData = AddressEntity(
      address: state.address,
      houseNumber: state.houseNumber,
      comment: state.comment.isEmpty ? null : state.comment,
      entrance: state.entrance.isEmpty ? null : state.entrance,
      floor: state.floor.isEmpty ? null : state.floor,
      intercom: state.intercom.isEmpty ? null : state.intercom,
      kvOffice: state.apartment.isEmpty ? null : state.apartment,
      region: state.address, // Используем address как region
    );

    // Создаем ContactInfoEntity из state
    final contactInfo = ContactInfoEntity(
      userName: state.userName,
      userPhone: state.userPhone,
    );

    // Вызываем метод создания шаблона через Cubit
    templatesCubit.createTemplateFromOrder(
      templateName: templateName,
      addressData: addressData,
      contactInfo: contactInfo,
      price: state.deliveryPrice.toInt(),
    );
  }

  void _onConfirmOrder(BuildContext context, DeliveryFormLoaded state) {
    context.read<DeliveryFormCubit>().confirmOrder(
          cart: cart,
          region: state.address, // Используем address как region
        );
  }
}
