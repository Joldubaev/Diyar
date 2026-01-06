import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/presentation/cubit/order_cubit.dart';
import 'package:diyar/features/templates/presentation/cubit/templates_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Действия в bottom sheet подтверждения заказа
class OrderConfirmationActions extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onConfirmOrder;
  final VoidCallback onSaveTemplate;

  const OrderConfirmationActions({
    super.key,
    required this.theme,
    required this.onConfirmOrder,
    required this.onSaveTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSaveTemplateButton(context),
        const SizedBox(height: 12),
        _buildConfirmButton(context),
      ],
    );
  }

  Widget _buildSaveTemplateButton(BuildContext context) {
    return BlocBuilder<TemplatesListCubit, TemplatesListState>(
      builder: (context, state) {
        final isLoading = state is TemplateCreateLoading;
        return OutlinedButton.icon(
          onPressed: isLoading ? null : onSaveTemplate,
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
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return SubmitButtonWidget(
          textStyle: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
          title: context.l10n.confirm,
          bgColor: AppColors.green,
          isLoading: state is CreateOrderLoading,
          onTap: onConfirmOrder,
        );
      },
    );
  }
}

