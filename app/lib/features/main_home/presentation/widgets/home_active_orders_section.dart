import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/presentation/widgets/banner_content_widget.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeActiveOrdersSection extends StatelessWidget {
  const HomeActiveOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
      builder: (context, activeState) {
        return BlocBuilder<HomeContentCubit, HomeContentState>(
          buildWhen: (prev, curr) => curr is HomeContentLoading || curr is HomeContentLoaded,
          builder: (context, homeState) {
            // ActiveOrderCubit — приоритетный источник (есть реал-тайм SignalR обновления).
            // HomeContentCubit — fallback при первичной загрузке.
            final int count;
            if (activeState is ActiveOrdersLoaded) {
              count = activeState.orders.length;
            } else if (homeState is HomeContentLoaded) {
              count = homeState.activeOrders.length;
            } else {
              count = 0;
            }

            if (count == 0) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BannerContent(
                ordersCount: count,
                onTap: () => context.router.push(const ActiveOrderRoute()),
              ),
            );
          },
        );
      },
    );
  }
}
