// import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/presentation/widgets/drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'curier_order_card.dart';
import '../widgets/state_widgets.dart';

@RoutePage()
class CurierPage extends StatefulWidget {
  const CurierPage({super.key});

  @override
  State<CurierPage> createState() => _CurierPageState();
}

class _CurierPageState extends State<CurierPage> {
  @override
  void initState() {
    super.initState();
    context.read<CurierCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          l10n.activeOrders,
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      drawer: Theme(
        data: theme.copyWith(iconTheme: IconThemeData(color: theme.colorScheme.onSurface)),
        child: const CustomDrawer(),
      ),
      body: BlocConsumer<CurierCubit, CurierState>(
        listener: (context, state) {
          if (state is UserError) {
            _handleLogout(context);
          } else if (state is UserLoaded) {
            context.read<CurierCubit>().getCurierOrders();
          } else if (state is FinishOrderSuccess) {
            context.read<CurierCubit>().getCurierOrders();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.orderCompleted)));
          } else if (state is FinishOrderError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is OrdersLoading || state is UserLoading) {
            return context.loadingIndicator;
          }

          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) return const EmptyCurierOrder();

            return RefreshIndicator(
              onRefresh: () async => context.read<CurierCubit>().getCurierOrders(),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  log('CurierPage: Building order card for order number ${order.orderNumber}');
                  return CurierOrderCard(
                    order: order,
                    onFinish: () => context.read<CurierCubit>().getFinishOrder(order.orderNumber ?? 0),
                    onOpenMap: () async {
                      final address = '${order.address ?? ''} ${order.houseNumber ?? ''}';
                      final url = 'https://2gis.kg/kyrgyzstan/search/${Uri.encodeComponent(address)}';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      }
                    },
                    onDetails: () => context.router.push(OrderDetailRoute(orderNumber: "${order.orderNumber}")),
                    onCall: () async {
                      final uri = Uri(scheme: 'tel', path: '+${order.userPhone ?? ''}');
                      if (await canLaunchUrl(uri)) await launchUrl(uri);
                    },
                  );
                },
              ),
            );
          }
          return const EmptyCurierOrder();
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: SubmitButtonWidget(
          onTap: () => context.read<CurierCubit>().getCurierOrders(),
          title: 'Обновить',
          bgColor: AppColors.primary,
          textStyle: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  // Оставляем только те методы, которые реально переиспользуются или слишком тяжелые для build
  void _handleLogout(BuildContext context) {
    context.read<SignInCubit>().logout().then((_) {
      if (context.mounted) {
        context.router.pushAndPopUntil(const MainHomeRoute(), predicate: (_) => false);
      }
    });
  }

  void _showLogoutDialog(BuildContext context) {
    AppAlert.showConfirmDialog(
      context: context,
      title: context.l10n.exit,
      content: Text(context.l10n.areYouSure),
      confirmPressed: () {
        Navigator.pop(context);
        _handleLogout(context);
      },
      cancelPressed: () => Navigator.pop(context),
      confirmText: context.l10n.yes,
      cancelText: context.l10n.no,
    );
  }
}
