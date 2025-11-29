import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'curier_order_card.dart';

@RoutePage()
class CurierPage extends StatefulWidget {
  const CurierPage({super.key});
  @override
  State<CurierPage> createState() => _CurierPageState();
}

class _CurierPageState extends State<CurierPage> {
  final mapControllerCompleter = Completer<YandexMapController>();
  List<CurierEntity> orders = [];

  @override
  void initState() {
    context.read<CurierCubit>().getUser().then(
      (value) {
        if (mounted) {
          context.read<CurierCubit>().getCurierOrders();
        }
      },
    );
    super.initState();
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _refresh() async {
    context.read<CurierCubit>().getCurierOrders();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          context.l10n.activeOrders,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: theme.colorScheme.onPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: theme.colorScheme.onPrimary),
            onPressed: () {
              AppAlert.showConfirmDialog(
                context: context,
                title: context.l10n.exit,
                content: Text(context.l10n.areYouSure),
                cancelText: context.l10n.no,
                confirmText: context.l10n.yes,
                cancelPressed: () => Navigator.pop(context),
                confirmPressed: () {
                  context.read<SignInCubit>().logout().then((value) {
                    if (context.mounted) {
                      context.router.pushAndPopUntil(
                        const MainRoute(),
                        predicate: (_) => false,
                      );
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
      drawerScrimColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        ),
        child: const CustomDrawer(),
      ),
      body: BlocConsumer<CurierCubit, CurierState>(
        listener: (context, state) {
          if (state is GetUserError) {
            final cubit = context.read<SignInCubit>();
            cubit.logout().then((value) {
              if (context.mounted) {
                context.router.pushAndPopUntil(
                  const MainRoute(),
                  predicate: (_) => false,
                );
              }
            });
          }
        },
        builder: (context, state) {
          if (state is GetCourierOrdersError) {
            return const Center(child: EmptyCurierOrder());
          } else if (state is GetCourierOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCourierOrdersLoaded) {
            orders = state.curiers;
          }
          return orders.isEmpty
              ? const EmptyCurierOrder()
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    padding: const EdgeInsets.all(20),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final address = '${order.address ?? ''} ${order.houseNumber ?? ''}';
                      return CurierOrderCard(
                        order: order,
                        onFinish: () => _finishOrder(order.orderNumber ?? 0, context: context),
                        onOpenMap: () => _openAddressIn2GIS(address, context: context),
                        onDetails: () => context.router.push(
                          OrderDetailRoute(orderNumber: "${order.orderNumber}"),
                        ),
                        onCall: () => makePhoneCall('+${order.userPhone ?? ''}'),
                      );
                    },
                  ),
                );
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SubmitButtonWidget(
          onTap: () => _refresh(),
          title: 'Обновить',
          bgColor: AppColors.primary,
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Future<void> _finishOrder(int orderNumber, {required BuildContext context}) async {
    final cubit = context.read<CurierCubit>();
    final snackBar = ScaffoldMessenger.of(context);
    try {
      await cubit.getFinishOrder(orderNumber);
      if (context.mounted) {
        snackBar.showSnackBar(
          SnackBar(content: Text(context.l10n.orderCompleted)),
        );
      }
      if (context.mounted) {
        cubit.getCurierOrders();
      }
    } catch (error) {
      if (context.mounted) {
        snackBar.showSnackBar(
          SnackBar(content: Text(context.l10n.errorCompletingOrder)),
        );
      }
    }
  }

  void _openAddressIn2GIS(String address, {required BuildContext context}) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url = 'https://2gis.kg/kyrgyzstan/search/$encodedAddress';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (context.mounted) {
        throw Text('${context.l10n.couldNotLaunch}$url');
      }
    }
  }
}
