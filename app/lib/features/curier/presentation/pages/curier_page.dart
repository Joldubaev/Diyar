import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/presentation/widgets/drawer/custom_drawer.dart';
import 'package:diyar/injection_container.dart';
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
  final _mapService = sl<MapService>();

  @override
  void initState() {
    super.initState();
    log('[CurierPage] initState: Инициализация страницы');
    _initializeData();
  }

  void _initializeData() {
    log('[CurierPage] _initializeData: Начало инициализации данных');
    final cubit = context.read<CurierCubit>();
    final currentState = cubit.state;
    log('[CurierPage] _initializeData: Текущее состояние - ${currentState.runtimeType}');
    log('[CurierPage] _initializeData: user = ${currentState.user?.userName ?? 'null'}, activeOrders = ${currentState.activeOrders.length}');

    if (currentState.user == null) {
      log('[CurierPage] _initializeData: Пользователь не загружен, вызываем getUser()');
      cubit.getUser();
    } else if (currentState.activeOrders.isEmpty) {
      log('[CurierPage] _initializeData: Пользователь загружен, но заказов нет, вызываем getCurierOrders()');
      cubit.getCurierOrders();
    } else {
      log('[CurierPage] _initializeData: Данные уже загружены, инициализация не требуется');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              log('[CurierPage] Listener 1: Сработал listener для UserError/FinishOrder');
              log('[CurierPage] Listener 1: Новое состояние - ${state.runtimeType}');

              if (state is UserError) {
                log('[CurierPage] Listener 1: Обнаружена ошибка пользователя, выполняем logout');
                _handleLogout(context);
              }
              if (state is FinishOrderSuccess) {
                log('[CurierPage] Listener 1: Заказ успешно завершен');
                SnackBarMessage().showSuccessSnackBar(message: l10n.orderCompleted, context: context);
              }
              if (state is FinishOrderError) {
                log('[CurierPage] Listener 1: Ошибка при завершении заказа: ${state.message}');
                SnackBarMessage().showErrorSnackBar(message: state.message, context: context);
              }
            },
          ),
          // Автоматическая загрузка заказов при переходе в CurierMainState
          BlocListener<CurierCubit, CurierState>(
            listenWhen: (p, c) {
              // Слушаем переход в CurierMainState, когда пользователь загружен, но заказов нет и они не загружаются
              final shouldListen = p is! CurierMainState &&
                  c is CurierMainState &&
                  c.user != null &&
                  c.activeOrders.isEmpty &&
                  !c.isActiveOrdersLoading;
              if (shouldListen) {
                log('[CurierPage] Listener 2: Переход в CurierMainState, пользователь загружен, но заказов нет');
                log('[CurierPage] Listener 2: Автоматически загружаем заказы');
              }
              return shouldListen;
            },
            listener: (context, state) {
              context.read<CurierCubit>().getCurierOrders();
            },
          ),
          // Отдельный листер для ошибок внутри MainState
          BlocListener<CurierCubit, CurierState>(
            listenWhen: (p, c) {
              final shouldListen = p.activeOrdersError != c.activeOrdersError && c.activeOrdersError != null;
              if (shouldListen) {
                log('[CurierPage] Listener 3: Обнаружена ошибка активных заказов: ${c.activeOrdersError}');
              }
              return shouldListen;
            },
            listener: (context, state) {
              log('[CurierPage] Listener 3: Показываем ошибку активных заказов');
              SnackBarMessage().showErrorSnackBar(
                message: state.activeOrdersError!,
                context: context,
              );
            },
          ),
        ],
        child: BlocBuilder<CurierCubit, CurierState>(
          // ПЕРЕРИСОВЫВАЕМ только если изменились данные активных заказов
          buildWhen: (p, c) {
            final shouldBuild = p.isActiveOrdersLoading != c.isActiveOrdersLoading ||
                p.activeOrders != c.activeOrders ||
                (p is UserLoading) != (c is UserLoading);

            if (shouldBuild) {
              log('[CurierPage] buildWhen: Перерисовка разрешена');
              log('[CurierPage] buildWhen: Предыдущее состояние - ${p.runtimeType}, isActiveOrdersLoading=${p.isActiveOrdersLoading}, activeOrders=${p.activeOrders.length}');
              log('[CurierPage] buildWhen: Новое состояние - ${c.runtimeType}, isActiveOrdersLoading=${c.isActiveOrdersLoading}, activeOrders=${c.activeOrders.length}');
            }

            return shouldBuild;
          },
          builder: (context, state) {
            log('[CurierPage] Builder: Построение UI для состояния ${state.runtimeType}');
            log('[CurierPage] Builder: isActiveOrdersLoading=${state.isActiveOrdersLoading}, activeOrders=${state.activeOrders.length}');

            // 1. Состояние первичной загрузки пользователя
            if (state is UserLoading || state is UserInitial) {
              log('[CurierPage] Builder: Показываем индикатор загрузки (UserLoading/UserInitial)');
              return context.loadingIndicator;
            }

            // 2. Если заказы загружаются и список пока пуст
            if (state.isActiveOrdersLoading && state.activeOrders.isEmpty) {
              log('[CurierPage] Builder: Показываем индикатор загрузки (заказы загружаются, список пуст)');
              return context.loadingIndicator;
            }

            // 3. Список заказов
            if (state.activeOrders.isNotEmpty) {
              log('[CurierPage] Builder: Показываем список заказов (${state.activeOrders.length} шт.)');
              return RefreshIndicator(
                onRefresh: () async {
                  log('[CurierPage] Builder: Pull-to-refresh: Обновление заказов');
                  context.read<CurierCubit>().getCurierOrders();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  itemCount: state.activeOrders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final order = state.activeOrders[index];
                    log('[CurierPage] Builder: Построение карточки заказа #${order.orderNumber} (индекс $index)');
                    return CurierOrderCard(
                      order: order,
                      onFinish: () {
                        log('[CurierPage] Builder: Завершение заказа #${order.orderNumber}');
                        context.read<CurierCubit>().getFinishOrder(order.orderNumber ?? 0);
                      },
                      onOpenMap: () {
                        log('[CurierPage] Builder: Открытие карты для заказа #${order.orderNumber}');
                        _mapService.open2GIS(context, '${order.address} ${order.houseNumber}');
                      },
                      onDetails: () {
                        log('[CurierPage] Builder: Показ деталей заказа #${order.orderNumber}');
                        context.router.push(OrderDetailRoute(orderNumber: "${order.orderNumber}"));
                      },
                      onCall: () {
                        log('[CurierPage] Builder: Звонок клиенту заказа #${order.orderNumber}, телефон: ${order.userPhone}');
                        _makeCall(order.userPhone);
                      },
                    );
                  },
                ),
              );
            }

            // 4. Пустое состояние
            log('[CurierPage] Builder: Показываем пустое состояние (заказов нет)');
            return const EmptyCurierOrder();
          },
        ),
      ),
      bottomSheet: _buildRefreshButton(theme),
    );
  }

  Widget _buildRefreshButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: SubmitButtonWidget(
        onTap: () {
          log('[CurierPage] _buildRefreshButton: Нажата кнопка обновления');
          context.read<CurierCubit>().getCurierOrders();
        },
        title: 'Обновить',
        bgColor: AppColors.primary,
        textStyle: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
    );
  }

  Future<void> _makeCall(String? phone) async {
    log('[CurierPage] _makeCall: Начало звонка, телефон: $phone');
    if (phone == null || phone.isEmpty) {
      log('[CurierPage] _makeCall: Телефон пустой, выход');
      return;
    }
    final uri = Uri(scheme: 'tel', path: '+$phone');
    log('[CurierPage] _makeCall: URI создан: $uri');
    if (await canLaunchUrl(uri)) {
      log('[CurierPage] _makeCall: Запуск звонка');
      await launchUrl(uri);
      log('[CurierPage] _makeCall: Звонок запущен');
    } else {
      log('[CurierPage] _makeCall: Не удалось запустить звонок (canLaunchUrl вернул false)');
    }
  }

  void _handleLogout(BuildContext context) {
    log('[CurierPage] _handleLogout: Начало выхода из системы');
    context.read<SignInCubit>().logout().then((_) {
      log('[CurierPage] _handleLogout: Выход выполнен, переход на главную');
      if (context.mounted) {
        context.router.pushAndPopUntil(const MainHomeRoute(), predicate: (_) => false);
      }
    });
  }

  void _showLogoutDialog(BuildContext context) {
    log('[CurierPage] _showLogoutDialog: Показ диалога подтверждения выхода');
    AppAlert.showConfirmDialog(
      context: context,
      title: context.l10n.exit,
      content: Text(context.l10n.areYouSure),
      confirmPressed: () {
        log('[CurierPage] _showLogoutDialog: Пользователь подтвердил выход');
        Navigator.pop(context);
        _handleLogout(context);
      },
      cancelPressed: () {
        log('[CurierPage] _showLogoutDialog: Пользователь отменил выход');
        Navigator.pop(context);
      },
      confirmText: context.l10n.yes,
      cancelText: context.l10n.no,
    );
  }
}
