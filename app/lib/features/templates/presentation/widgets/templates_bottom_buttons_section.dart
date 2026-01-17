import 'package:collection/collection.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/templates/presentation/presentation.dart';
import 'package:diyar/features/templates/presentation/widgets/template_bottom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Оптимизированная секция кнопок через BlocSelector
/// Перерисовывается только при изменении состояния корзины
/// Адаптирована для работы с текущей логикой (навигация через BlocListener, не callbacks)
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
        context.read<TemplatesListCubit>().applySelectedTemplate(cartState);
      },
      onSkip: () {
        context.read<TemplatesListCubit>().skipToMap(cartState);
      },
    );
  }
}
