import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'banner_content_widget.dart';

class ActiveOrdersBannerWidget extends StatefulWidget {
  const ActiveOrdersBannerWidget({super.key});

  @override
  State<ActiveOrdersBannerWidget> createState() => _ActiveOrdersBannerWidgetState();
}

class _ActiveOrdersBannerWidgetState extends State<ActiveOrdersBannerWidget> {
  @override
  void initState() {
    super.initState();
    if (UserHelper.isAuth()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.read<ActiveOrderCubit>().state is ActiveOrderInitial) {
          unawaited(context.read<ActiveOrderCubit>().getActiveOrders());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!UserHelper.isAuth()) return const SizedBox.shrink();

    return BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
      builder: (context, state) {
        if (state is ActiveOrdersLoaded && state.orders.isNotEmpty) {
          return BannerContent(
            ordersCount: state.orders.length,
            onTap: () => context.router.push(const ActiveOrderRoute()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
