import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/presentation/widgets/drawer/custom_drawer.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'curier_order_card.dart';

@RoutePage()
class CurierPage extends StatefulWidget {
  const CurierPage({super.key});

  @override
  State<CurierPage> createState() => _CurierPageState();
}

class _CurierPageState extends State<CurierPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _mapService = di.sl<MapService>();
  final _courierLocationHub = di.sl<CourierLocationHubService>();

  late final CurierCubit _cubit;
  late final SignInCubit _signInCubit;
  bool _shiftToggleLoading = false;

  @override
  void initState() {
    super.initState();
    _cubit = di.sl<CurierCubit>();
    _signInCubit = di.sl<SignInCubit>();
    _courierLocationHub.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final s = _cubit.state;
      if (s.user == null) {
        _cubit.getUser();
      } else if (s.activeOrders.isEmpty && !s.isActiveOrdersLoading) {
        _cubit.getCurierOrders();
      }
    });
  }

  @override
  void dispose() {
    _courierLocationHub.stop();
    _cubit.close();
    _signInCubit.close();
    super.dispose();
  }

  Future<void> _toggleShift(BuildContext context) async {
    final cubit = context.read<CurierCubit>();
    final wasOnShift = cubit.state.isOnShift;

    setState(() => _shiftToggleLoading = true);
    final success = await cubit.setOnShift(!wasOnShift);
    if (!mounted) return;
    setState(() => _shiftToggleLoading = false);

    if (!context.mounted) return;
    if (success) {
      SnackBarMessage().showSuccessSnackBar(
        message: !wasOnShift ? 'Вы на смене' : 'Смена завершена',
        context: context,
      );
    } else {
      SnackBarMessage().showErrorSnackBar(
        message: 'Не удалось изменить статус смены',
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _signInCubit),
      ],
      child: Builder(
        builder: (context) {
          final l10n = context.l10n;

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.backgroundGrey,
            endDrawer: const CustomDrawer(),
            body: MultiBlocListener(
              listeners: [
                BlocListener<CurierCubit, CurierState>(
                  listenWhen: (p, c) =>
                      c is UserError ||
                      c is FinishOrderSuccess ||
                      c is FinishOrderError ||
                      c is StartDeliverySuccess,
                  listener: (context, state) {
                    if (state is UserError) _handleLogout(context);
                    if (state is FinishOrderSuccess) {
                      SnackBarMessage().showSuccessSnackBar(
                        message: l10n.orderCompleted,
                        context: context,
                      );
                    }
                    if (state is FinishOrderError) {
                      SnackBarMessage().showErrorSnackBar(
                        message: state.message,
                        context: context,
                      );
                    }
                    if (state is StartDeliverySuccess) {
                      SnackBarMessage().showSuccessSnackBar(
                        message: 'Заказ взят в доставку',
                        context: context,
                      );
                    }
                  },
                ),
                BlocListener<CurierCubit, CurierState>(
                  listenWhen: (p, c) =>
                      p is! CurierMainState &&
                      c is CurierMainState &&
                      c.user != null &&
                      c.activeOrders.isEmpty &&
                      !c.isActiveOrdersLoading,
                  listener: (context, state) =>
                      context.read<CurierCubit>().getCurierOrders(),
                ),
                BlocListener<CurierCubit, CurierState>(
                  listenWhen: (p, c) =>
                      p.activeOrdersError != c.activeOrdersError &&
                      c.activeOrdersError != null,
                  listener: (context, state) => SnackBarMessage().showErrorSnackBar(
                    message: state.activeOrdersError!,
                    context: context,
                  ),
                ),
              ],
              child: SafeArea(
                child: BlocBuilder<CurierCubit, CurierState>(
                  builder: (context, state) {
                    if (state is UserLoading || state is UserInitial || state.user == null) {
                      return const CurierPageShimmer();
                    }

                    final user = state.user!;

                    return RefreshIndicator(
                      onRefresh: () async =>
                          context.read<CurierCubit>().getCurierOrders(),
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: CurierHeaderWidget(
                              user: user,
                              onMenuTap: () =>
                                  _scaffoldKey.currentState?.openEndDrawer(),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ShiftToggleCard(
                                isOnShift: state.isOnShift,
                                isLoading: _shiftToggleLoading,
                                onToggle: () => _toggleShift(context),
                              ),
                            ),
                          ),
                          if (!state.isOnShift)
                            const SliverFillRemaining(
                              hasScrollBody: false,
                              child: SizedBox.shrink(),
                            )
                          else if (state.isActiveOrdersLoading &&
                              state.activeOrders.isEmpty)
                            const CurierOrdersShimmer()
                          else if (state.activeOrders.isEmpty)
                            const SliverFillRemaining(child: EmptyCurierOrder())
                          else
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                              sliver: SliverList.separated(
                                itemCount: state.activeOrders.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final order = state.activeOrders[index];
                                  return CurierOrderCard(
                                    order: order,
                                    onFinish: () =>
                                        _showFinishDialog(context, order),
                                    onStartDelivery: order.status == CurierConstants.statusCooked
                                        ? () => _showStartDeliveryDialog(
                                            context, order)
                                        : null,
                                    onOpenMap: () => _mapService.open2GIS(
                                      context,
                                      '${order.address} ${order.houseNumber}',
                                    ),
                                    onDetails: () => context.router.push(
                                      OrderDetailRoute(
                                        orderNumber: '${order.orderNumber}',
                                      ),
                                    ),
                                    onCall: () => _makeCall(order.userPhone),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFinishDialog(BuildContext context, CurierEntity order) {
    final status = PaymentStatus.fromString(order.paymentStatus);
    final method = PaymentMethod.fromString(order.paymentMethod);

    final statusText = (status?.isPaid ?? false)
        ? 'Оплата по заказу уже отмечена как полученная.'
        : 'Оплата по заказу ещё не отмечена как полученная.';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Завершить заказ #${order.orderNumber}?'),
        content: Text(
          '$statusText\n\nКлиент оплатил заказ'
          '${method.isCash ? ' НАЛИЧНЫМИ' : ''}? Подтвердить завершение?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CurierCubit>().finishOrder(order);
            },
            child: const Text('Да, завершить'),
          ),
        ],
      ),
    );
  }

  void _showStartDeliveryDialog(BuildContext context, CurierEntity order) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Забрать заказ #${order.orderNumber}?'),
        content: const Text(
          'Подтвердите, что вы физически забрали заказ из ресторана и выезжаете к клиенту.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context
                  .read<CurierCubit>()
                  .startDelivery(order.orderNumber ?? 0);
            },
            child: const Text('Да, забрал'),
          ),
        ],
      ),
    );
  }

  Future<void> _makeCall(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: '+$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _handleLogout(BuildContext context) {
    context.read<SignInCubit>().logout().then((_) {
      if (context.mounted) {
        context.router
            .pushAndPopUntil(const MainHomeRoute(), predicate: (_) => false);
      }
    });
  }
}
