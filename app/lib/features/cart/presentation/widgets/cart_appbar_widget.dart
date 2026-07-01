import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        onPressed: () => context.maybePop(),
      ),
      title: Text(
        context.l10n.cart,
        style: theme.textTheme.titleSmall?.copyWith(color: AppColors.white),
      ),
      actions: [
        // Кнопка очистки видна только при непустой корзине.
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final hasItems = state is CartLoaded && state.items.isNotEmpty;
            if (!hasItems) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.white),
              tooltip: context.l10n.clearCart,
              onPressed: () => _onClearPressed(context),
            );
          },
        ),
      ],
    );
  }

  Future<void> _onClearPressed(BuildContext context) async {
    final cartBloc = context.read<CartBloc>();
    final l10n = context.l10n;

    final confirmed = await DeleteConfirmationDialog.show(
      context: context,
      title: l10n.clearCart,
      message: l10n.clearCartText,
      cancelText: l10n.no,
      deleteText: l10n.yes,
    );

    if (confirmed == true) {
      cartBloc.add(ClearCart());
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
