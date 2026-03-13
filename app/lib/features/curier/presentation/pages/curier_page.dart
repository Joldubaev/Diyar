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
import '../widgets/state_widgets.dart';

@RoutePage()
class CurierPage extends StatefulWidget {
  const CurierPage({super.key});

  @override
  State<CurierPage> createState() => _CurierPageState();
}

class _CurierPageState extends State<CurierPage> {
  final _mapService = di.sl<MapService>();
  final _courierLocationHub = di.sl<CourierLocationHubService>();

  @override
  void initState() {
    super.initState();
    _courierLocationHub.start();
  }

  @override
  void dispose() {
    _courierLocationHub.stop();
    super.dispose();
  }

  void _initializeDataCallback(BuildContext context) {
    if (!mounted) return;
    final cubit = context.read<CurierCubit>();
    final currentState = cubit.state;

    if (currentState.user == null) {
      cubit.getUser();
    } else if (currentState.activeOrders.isEmpty) {
      cubit.getCurierOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<CurierCubit>()),
          BlocProvider(create: (_) => di.sl<SignInCubit>()),
        ],
        child: Builder(builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _initializeDataCallback(context));

          final theme = Theme.of(context);
          final l10n = context.l10n;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.colorScheme.primary,
              title: Text(l10n.activeOrders, style: const TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => _showLogoutDialog(context),
                ),
              ],
            ),
            drawer: const CustomDrawer(),
            body: MultiBlocListener(
              listeners: [
                BlocListener<CurierCubit, CurierState>(
                  listenWhen: (p, c) => c is UserError || c is FinishOrderSuccess || c is FinishOrderError,
                  listener: (context, state) {
                    if (state is UserError) _handleLogout(context);
                    if (state is FinishOrderSuccess) {
                      SnackBarMessage().showSuccessSnackBar(message: l10n.orderCompleted, context: context);
                    }
                    if (state is FinishOrderError) {
                      SnackBarMessage().showErrorSnackBar(message: state.message, context: context);
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
                  listener: (context, state) => context.read<CurierCubit>().getCurierOrders(),
                ),
                BlocListener<CurierCubit, CurierState>(
                  listenWhen: (p, c) => p.activeOrdersError != c.activeOrdersError && c.activeOrdersError != null,
                  listener: (context, state) => SnackBarMessage().showErrorSnackBar(
                    message: state.activeOrdersError!,
                    context: context,
                  ),
                ),
              ],
              child: BlocBuilder<CurierCubit, CurierState>(
                buildWhen: (p, c) =>
                    p.isActiveOrdersLoading != c.isActiveOrdersLoading ||
                    p.activeOrders != c.activeOrders ||
                    (p is UserLoading) != (c is UserLoading),
                builder: (context, state) {
                  if (state is UserLoading || state is UserInitial) return context.loadingIndicator;
                  if (state.isActiveOrdersLoading && state.activeOrders.isEmpty) return context.loadingIndicator;

                  if (state.activeOrders.isNotEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async => context.read<CurierCubit>().getCurierOrders(),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                        itemCount: state.activeOrders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final order = state.activeOrders[index];
                          return CurierOrderCard(
                            order: order,
                            onFinish: () => _showFinishDialog(context, order),
                            onOpenMap: () => _mapService.open2GIS(context, '${order.address} ${order.houseNumber}'),
                            onDetails: () => context.router.push(OrderDetailRoute(orderNumber: "${order.orderNumber}")),
                            onCall: () => _makeCall(order.userPhone),
                          );
                        },
                      ),
                    );
                  }

                  return const EmptyCurierOrder();
                },
              ),
            ),
            bottomSheet: _buildRefreshButton(context, theme),
          );
        }));
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
          '$statusText\n\nКлиент оплатил заказ${method.isCash ? ' НАЛИЧНЫМИ' : ''}? Подтвердить завершение?',
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

  Widget _buildRefreshButton(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: SubmitButtonWidget(
        onTap: () => context.read<CurierCubit>().getCurierOrders(),
        title: 'Обновить',
        bgColor: AppColors.primary,
        textStyle: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
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
