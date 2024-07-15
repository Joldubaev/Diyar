import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/profile/prof.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'delivery_order.dart';

@RoutePage()
class CreateOrderPage extends StatefulWidget {
  final List<CartItemModel> cart;
  final int dishCount;
  const CreateOrderPage(
      {super.key, required this.cart, required this.dishCount});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  UserModel? user;

  @override
  void initState() {
    context.read<ProfileCubit>().getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileGetLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProfileGetLoaded) {
          user = state.userModel;
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.colorScheme.surface,
              title: Text(context.l10n.orderDetails,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: theme.colorScheme.onSurface)),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: theme.colorScheme.onSurface.withOpacity(0.1)),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    labelColor: theme.colorScheme.surface,
                    unselectedLabelColor: theme.colorScheme.onSurface,
                    tabs: [
                      TabItem(title: context.l10n.delivery),
                      TabItem(title: context.l10n.pickup),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                DeliveryFormPage(cart: widget.cart, user: user),
                PickupForm(cart: widget.cart, user: user),
              ],
            ),
          ),
        );
      },
    );
  }
}
