import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/data/data.dart';
import 'package:diyar/features/menu/data/models/food_model.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/features/cart/presentation/presentation.dart';
import 'package:diyar/features/cart/presentation/widgets/cart_empty_widget.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    context.read<CartCubit>().getCartItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () => context.maybePop(),
          ),
          title: Text(context.l10n.cart,
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: AppColors.white))),
      body: StreamBuilder<List<CartItemModel>>(
        stream: context.read<CartCubit>().cart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final carts = snapshot.data!;
            final containerPrice = carts.fold(
              0,
              (prevValue, element) =>
                  prevValue +
                  (element.food?.containerPrice ?? 0) * (element.quantity ?? 0),
            );
            final totalPrice = containerPrice +
                (carts.fold(
                            0,
                            (prevValue, element) =>
                                prevValue +
                                (element.food?.price ?? 0) *
                                    (element.quantity ?? 0)) *
                        0.9)
                    .toInt();
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: carts.length,
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    itemBuilder: (context, index) {
                      return CartItemWidgets(
                        counter: carts[index].quantity ?? 0,
                        food: carts[index].food ?? FoodModel(),
                        onRemove: () {
                          context
                              .read<CartCubit>()
                              .removeFromCart(carts[index].food!.id ?? '');
                          context.maybePop();
                          if (carts.length == 1) {
                            context.read<CartCubit>().dishCount = 0;
                          }
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    child: TotalPriceWidget(
                      containerPrice: containerPrice,
                      price: (carts.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue +
                                    (element.food?.price ?? 0) *
                                        (element.quantity ?? 0),
                              ) *
                              0.9)
                          .toInt(),
                      sale: 10,
                      totalPrice: totalPrice,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    child: SubmitButtonWidget(
                      textStyle: theme.textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.surface),
                      bgColor: Theme.of(context).colorScheme.primary,
                      title: context.l10n.confirmOrder,
                      onTap: () {
                        _showDeliveryDialog(context, carts, totalPrice);
                        context.read<CartCubit>().dishCount = 0;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return const CartEmptyWidget();
          }
        },
      ),
    );
  }

  Future<dynamic> _showDeliveryDialog(
      BuildContext context, List<CartItemModel> carts, int totalPrice) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Выберите способ доставки',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.red),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: CustomBoxWidget(
                      icon: Icons.delivery_dining,
                      label: context.l10n.delivery,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(
                            OrderMapRoute(cart: carts, totalPrice: totalPrice));
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomBoxWidget(
                      icon: Icons.store,
                      label: context.l10n.pickup,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(PickupFormRoute(
                            cart: carts, totalPrice: totalPrice));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
