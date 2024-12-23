import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/auth.dart';
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
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: theme.colorScheme.onPrimary),
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
            // Use a local variable to store the context before the async operation
            final cubit = context.read<SignInCubit>();

            // Use the cubit to handle the logout process
            cubit.logout().then((value) {
              // Check if the widget is still mounted before navigating
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    padding: const EdgeInsets.all(20),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final totalPrice = (orders[index].price ?? 0) +
                          (orders[index].deliveryPrice ?? 0);
                      return Card(
                        margin: const EdgeInsets.all(0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        elevation: 4,
                        child: ExpansionTile(
                          shape: const Border(
                            bottom: BorderSide(
                              color: AppColors.transparent,
                              width: 0,
                            ),
                          ),
                          childrenPadding:
                              const EdgeInsets.fromLTRB(10, 10, 10, 8),
                          title: Text(
                            '${context.l10n.orderNumber} ${orders[index].orderNumber}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: theme.colorScheme.onSurface),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orders[index].address.toString(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '${context.l10n.orderAmount} $totalPrice сом',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  TextButton.icon(
                                      onPressed: () => makePhoneCall(
                                          orders[index].userPhone.toString()),
                                      icon: const Icon(Icons.phone),
                                      label: const Text('Позвонить')),
                                ],
                              ),
                            ),
                            Divider(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                thickness: 1),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.2),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CustomTextButton(
                                      textStyle: theme.textTheme.bodySmall!
                                          .copyWith(color: AppColors.primary),
                                      onPressed: () {
                                        context.router.push(
                                          OrderDetailRoute(
                                            orderNumber:
                                                "${orders[index].orderNumber}",
                                          ),
                                        );
                                      },
                                      textButton: context.l10n.orderDetails,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.2),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CustomTextButton(
                                      textStyle: theme.textTheme.bodySmall!
                                          .copyWith(color: AppColors.primary),
                                      onPressed: () {
                                        _finishOrder(
                                            context: context,
                                            orders[index].orderNumber ?? 0);
                                      },
                                      textButton: context.l10n.finishOrder,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.2),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CustomTextButton(
                                      textStyle: theme.textTheme.bodySmall!
                                          .copyWith(color: AppColors.primary),
                                      onPressed: () {
                                        final address = orders[index].address;
                                        _openAddressIn2GIS(address!,
                                            context: context);
                                      },
                                      textButton: context.l10n.openOnMap,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
          textStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Future<void> _finishOrder(int orderNumber,
      {required BuildContext context}) async {
    // Capture the context and the current state
    final cubit = context.read<CurierCubit>();
    final snackBar = ScaffoldMessenger.of(context);

    try {
      await cubit.getFinishOrder(orderNumber);

      // Check if the widget is still mounted before showing the SnackBar
      if (context.mounted) {
        snackBar.showSnackBar(
          SnackBar(content: Text(context.l10n.orderCompleted)),
        );
      }

      // Refresh the orders only if the widget is still mounted
      if (context.mounted) {
        cubit.getCurierOrders();
      }
    } catch (error) {
      // Check if the widget is still mounted before showing the SnackBar
      if (context.mounted) {
        snackBar.showSnackBar(
          SnackBar(content: Text(context.l10n.errorCompletingOrder)),
        );
      }
    }
  }

  void _openAddressIn2GIS(String address,
      {required BuildContext context}) async {
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
