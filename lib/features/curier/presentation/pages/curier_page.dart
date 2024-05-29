import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/presentation/widgets/empty_curier.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

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
    context.read<CurierCubit>().getCuriers();
    super.initState();
  }

  Future<void> _refresh() async {
    context.read<CurierCubit>().getCuriers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(context.l10n.activeOrders, style: theme.textTheme.titleMedium!.copyWith(color: AppColors.white)),
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
          data: Theme.of(context).copyWith(iconTheme: const IconThemeData(color: AppColors.white)),
          child: const CustomDrawer()),
      body: BlocBuilder<CurierCubit, CurierState>(
        builder: (context, state) {
          if (state is GetCourierActualOrdersError) {
            return const Center(child: EmptyCurierOrder());
          } else if (state is GetCourierActualOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCourierActualOrdersLoaded) {
            orders = state.curiers;
          } else if (orders.isEmpty) {
            return const EmptyCurierOrder();
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(0),
                  child: ExpansionTile(
                    shape: const Border(bottom: BorderSide(color: Colors.transparent, width: 0)),
                    childrenPadding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                    title: Text(
                      '${context.l10n.orderNumber} ${orders[index].orderNumber}',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: AppColors.black1,
                      ),
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.copy_rounded),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: '${orders[index].address}'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(context.l10n.addressIsCopied)));
                          },
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.none,
                        child: Text('${orders[index].address}',
                            maxLines: 3, style: const TextStyle(color: AppColors.black1, fontSize: 13)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextButton(
                            onPressed: () {
                              context.router.push(
                                OrderDetailRoute(
                                  orderNumber: "${orders[index].orderNumber}",
                                ),
                              );
                            },
                            textButton: context.l10n.orderDetails,
                          ),
                          CustomTextButton(
                            onPressed: () {
                              _finishOrder(orders[index].orderNumber ?? 0).then((value) {
                                context.read<CurierCubit>().getCuriers();
                              });
                            },
                            textButton: context.l10n.finishOrder,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          AppLaunch.launchURL('https://2gis.kg/bishkek');
        },
        child: Image.asset('assets/images/gis.png'),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SubmitButtonWidget(
          onTap: () => _refresh(),
          title: 'Обновить',
          bgColor: AppColors.primary,
          textStyle: theme.textTheme.bodyLarge!.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Future _finishOrder(int orderNumber) async {
    context.read<CurierCubit>().getFinishOrder(orderNumber).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order completed')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error completing order')),
      );
    });
  }
}
