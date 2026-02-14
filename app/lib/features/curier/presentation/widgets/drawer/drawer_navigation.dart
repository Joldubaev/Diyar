import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'drawer_item.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerItem(
          icon: Icons.delivery_dining_outlined,
          title: 'Активные заказы',
          onTap: () {
            Navigator.pop(context);
            // Если мы на странице истории, возвращаемся на главную страницу курьера
            if (context.router.canPop()) {
              context.router.maybePop();
            }
            // Перезагружаем активные заказы
            context.read<CurierCubit>().getCurierOrders();
          },
        ),
        DrawerItem(
          icon: Icons.history_toggle_off_outlined,
          title: 'История заказов',
          onTap: () {
            context.router.push(const HistoryRoute());
          },
        ),
        const Divider(),
      ],
    );
  }
}
