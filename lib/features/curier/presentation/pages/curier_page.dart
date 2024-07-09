import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/curier/curier.dart';
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
        context.read<CurierCubit>().getCurierOrders();
      },
    );
    super.initState();
  }

  Future<void> _refresh() async {
    context.read<CurierCubit>().getCurierOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.l10n.activeOrders,
          style: theme.textTheme.titleMedium!.copyWith(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
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
                    context.router.pushAndPopUntil(
                      const SignInRoute(),
                      predicate: (_) => false,
                    );
                  });
                },
              );
            },
          ),
        ],
      ),
      drawerScrimColor: AppColors.black1.withOpacity(0.5),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: AppColors.white),
        ),
        child: const CustomDrawer(),
      ),
      body: BlocConsumer<CurierCubit, CurierState>(
        listener: (context, state) {
          if (state is GetUserError) {
            context.read<SignInCubit>().logout().then((value) {
              context.router.pushAndPopUntil(
                const MainRoute(),
                predicate: (_) => false,
              );
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: ExpansionTile(
                          shape: const Border(
                            bottom: BorderSide(
                              color: Colors.transparent,
                              width: 0,
                            ),
                          ),
                          childrenPadding:
                              const EdgeInsets.fromLTRB(10, 10, 10, 8),
                          title: Text(
                            '${context.l10n.orderNumber} ${orders[index].orderNumber}',
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: AppColors.black1,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    '${orders[index].address.toString()} ${orders[index].houseNumber.toString()}',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.black1,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Сумма заказа :$totalPrice сом',
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: AppColors.grey, thickness: 1),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors.black1.withOpacity(0.2),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CustomTextButton(
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
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors.black1.withOpacity(0.2),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CustomTextButton(
                                      onPressed: () {
                                        _finishOrder(
                                            orders[index].orderNumber ?? 0);
                                      },
                                      textButton: context.l10n.finishOrder,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors.black1.withOpacity(0.2),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CustomTextButton(
                                      onPressed: () {
                                        final address = orders[index].address;
                                        _openAddressIn2GIS(address!);
                                      },
                                      textButton: 'Открыть на карте',
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
          textStyle:
              theme.textTheme.bodyLarge!.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Future _finishOrder(int orderNumber) async {
    context.read<CurierCubit>().getFinishOrder(orderNumber).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order completed')),
      );
      context.read<CurierCubit>().getCurierOrders();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error completing order')),
      );
    });
  }

  void _openAddressIn2GIS(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url = 'https://2gis.kg/kyrgyzstan/search/$encodedAddress';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
