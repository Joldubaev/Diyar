import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/profile/profile.dart';
import 'package:diyar/features/templates/presentation/presentation.dart';
import 'package:diyar/features/templates/presentation/widgets/template_bottom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Оптимизированная секция кнопок через BlocSelector
/// Перерисовывается только при изменении состояния корзины
class TemplatesBottomButtonsSection extends StatelessWidget {
  final TemplatesListLoaded state;

  const TemplatesBottomButtonsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartBloc, CartState, CartLoaded?>(
      selector: (cartState) {
        if (cartState is CartLoaded && cartState.items.isNotEmpty) {
          return cartState;
        }
        return null;
      },
      builder: (context, cartLoaded) {
        if (cartLoaded == null) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: _TemplatesBottomButtons(
            state: state,
            cartState: cartLoaded,
          ),
        );
      },
    );
  }
}

class _TemplatesBottomButtons extends StatelessWidget {
  final TemplatesListLoaded state;
  final CartLoaded cartState;

  const _TemplatesBottomButtons({
    required this.state,
    required this.cartState,
  });

  @override
  Widget build(BuildContext context) {
    final selectedTemplate = state.selectedTemplateId != null
        ? state.templates.firstWhereOrNull(
            (t) => t.id == state.selectedTemplateId,
          )
        : null;

    return TemplateBottomButtons(
      selectedTemplateId: state.selectedTemplateId,
      cartState: cartState,
      selectedTemplate: selectedTemplate,
      onApplyTemplate: () {
        final cubit = context.read<TemplatesListCubit>();
        cubit.applySelectedTemplate(
          cartState,
          onSuccess: (navigationData) {
            // Получаем данные пользователя из ProfileCubit
            final profileCubit = context.read<ProfileCubit>();
            final user = profileCubit.user;

            context.router.push(
              DeliveryFormRoute(
                cart: navigationData.cart,
                totalPrice: navigationData.totalPrice,
                dishCount: navigationData.dishCount,
                deliveryPrice: navigationData.deliveryPrice,
                address: navigationData.address,
                initialUserName: user?.userName,
                initialUserPhone: user?.phone,
              ),
            );
            // Сбрасываем состояние навигации после выполнения
            cubit.resetNavigation();
          },
        );
      },
      onSkip: () {
        final cubit = context.read<TemplatesListCubit>();
        cubit.skipToMap(
          cartState,
          onSuccess: (navigationData) {
            context.router.push(
              OrderMapRoute(
                cart: navigationData.cart,
                totalPrice: navigationData.totalPrice,
                dishCount: navigationData.dishCount,
              ),
            );
            // Сбрасываем состояние навигации после выполнения
            cubit.resetNavigation();
          },
        );
      },
    );
  }
}
