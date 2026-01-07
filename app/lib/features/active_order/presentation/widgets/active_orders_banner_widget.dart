import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'banner_content_widget.dart';

/// Виджет для отображения баннера активных заказов на главном экране
/// Показывается только авторизованным пользователям с активными заказами
class ActiveOrdersBannerWidget extends StatelessWidget {
  const ActiveOrdersBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Показываем только авторизованным пользователям
    if (!UserHelper.isAuth()) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
      builder: (context, state) {
        // Показываем виджет только когда есть активные заказы
        if (state is ActiveOrdersLoaded && state.orders.isNotEmpty) {
          return BannerContent(
            ordersCount: state.orders.length,
            onTap: () => context.router.push(const ActiveOrderRoute()),
          );
        }

        // Загружаем заказы, если еще не загружали
        if (state is ActiveOrderInitial) {
          context.read<ActiveOrderCubit>().getActiveOrders();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
