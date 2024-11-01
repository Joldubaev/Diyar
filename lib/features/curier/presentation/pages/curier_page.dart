import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class CurierPage extends StatefulWidget {
  const CurierPage({super.key});

  @override
  State<CurierPage> createState() => _CurierPageState();
}

class _CurierPageState extends State<CurierPage> {
  final mapControllerCompleter = Completer<YandexMapController>();
  List<CurierOrderModel> orders = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await context.read<CurierCubit>().getUser();
    if (mounted) {
      context.read<CurierCubit>().getCurierOrders();
    }
  }

  Future<void> _refresh() async {
    context.read<CurierCubit>().getCurierOrders();
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  void _finishOrder(int orderNumber) async {
    try {
      await context.read<CurierCubit>().getFinishOrder(orderNumber);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.orderCompleted)),
        );
      }
      _refresh();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorCompletingOrder)),
        );
      }
    }
  }

  void _openAddressIn2GIS(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url = 'https://2gis.kg/kyrgyzstan/search/$encodedAddress';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      showToast('Не удалось открыть адрес в 2ГИС', isError: true);
    }
  }

  void _logout() {
    AppAlert.showConfirmDialog(
      context: context,
      title: context.l10n.exit,
      content: Text(context.l10n.areYouSure),
      cancelText: context.l10n.no,
      confirmText: context.l10n.yes,
      confirmPressed: () {
        context.read<SignInCubit>().logout().then((_) {
          if (mounted) {
            context.router.pushAndPopUntil(
              const MainRoute(),
              predicate: (_) => false,
            );
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.primary,
        title: Text(context.l10n.activeOrders,
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.colorScheme.onPrimary)),
        actions: [
          IconButton(
              icon: Icon(Icons.logout, color: theme.colorScheme.onPrimary),
              onPressed: _logout)
        ],
      ),
      body: BlocConsumer<CurierCubit, CurierState>(
        listener: (context, state) {
          if (state is GetUserError) _logout();
        },
        builder: (context, state) {
          if (state is GetCourierOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCourierOrdersError) {
            return const Center(child: EmptyCurierOrder());
          } else if (state is GetCourierOrdersLoaded) {
            orders = state.curiers;
          }

          return orders.isEmpty
              ? const EmptyCurierOrder()
              : _buildOrderList(context, theme);
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SubmitButtonWidget(
          onTap: _refresh,
          title: context.l10n.refresh,
          bgColor: AppColors.primary,
          textStyle:
              theme.textTheme.bodyLarge!.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final totalPrice = (order.price ?? 0) + (order.deliveryPrice ?? 0);
          return Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            elevation: 4,
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text('${context.l10n.orderNumber} ${order.orderNumber}',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurface)),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text(order.address ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14)),
                      Text('${context.l10n.orderAmount} $totalPrice сом',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold)),
                      TextButton.icon(
                          onPressed: () =>
                              _makePhoneCall(order.userPhone ?? ''),
                          icon: const Icon(Icons.phone),
                          label: const Text('Позвонить')),
                      const Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _actionButton(
                              context.l10n.orderDetails,
                              () => context.router.push(OrderDetailRoute(
                                  orderNumber: "${order.orderNumber}"))),
                          _actionButton(context.l10n.finishOrder,
                              () => _finishOrder(order.orderNumber ?? 0)),
                          _actionButton(context.l10n.openOnMap,
                              () => _openAddressIn2GIS(order.address ?? '')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: CustomTextButton(
        onPressed: onPressed,
        textButton: label,
        textStyle: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: AppColors.primary),
      ),
    );
  }
}
