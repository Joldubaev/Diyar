import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:diyar/features/cart/data/models/models.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/profile/prof.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CreateOrderPage extends StatefulWidget {
  final List<CartItemModel> cart;
  final int dishCount;
  const CreateOrderPage({super.key, required this.cart, required this.dishCount});

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
              backgroundColor: AppColors.white,
              title:
                  Text(context.l10n.orderDetails, style: theme.textTheme.titleLarge!.copyWith(color: AppColors.black1)),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: AppColors.grey.withOpacity(0.2),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelColor: AppColors.white,
                    unselectedLabelColor: Colors.black54,
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
