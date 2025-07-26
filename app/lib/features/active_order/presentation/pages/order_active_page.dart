import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/injection_container.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:collection/collection.dart';

@RoutePage()
class ActiveOrderPage extends StatefulWidget {
  const ActiveOrderPage({super.key});

  @override
  State<ActiveOrderPage> createState() => _ActiveOrderPageState();
}

class _ActiveOrderPageState extends State<ActiveOrderPage> {
  List<OrderActiveItemEntity> orders = [];
  late final HubConnection _hubConnection;
  final StreamController<List<OrderStatusEntity>> _controller = StreamController.broadcast();
  bool _isControllerClosed = false;

  @override
  void initState() {
    super.initState();
    _initializeSignalR();
    context.read<ActiveOrderCubit>().getActiveOrders();
    debugPrint('ActiveOrderPage initialized.');
  }

  void _initializeSignalR() async {
    var token = sl<SharedPreferences>().getString(AppConst.accessToken);
    debugPrint('Access Token: $token');
    if (token == null) {
      debugPrint('No token found.');
      return;
    }

    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final nameId = decodedToken['nameid'];
    debugPrint('Decoded nameid: $nameId');

    final serverUrl = "https://api.diyar.kg/order-status-hub";
    _hubConnection = HubConnectionBuilder().withUrl(serverUrl).configureLogging(Logger("SignalR")).build();

    // Подписка на событие получения статусов
    _hubConnection.on("ReceiveStatus", (data) {
      debugPrint("📦 Order statuses: $data");
      if (!_isControllerClosed && data != null && data.isNotEmpty) {
        try {
          final List<dynamic> list = data;
          final orderStatuses =
              list.map((json) => OrderStatusModel.fromJson(Map<String, dynamic>.from(json)).toEntity()).toList();
          debugPrint('Parsed orderStatuses: $orderStatuses');
          _controller.add(orderStatuses);
        } catch (e, s) {
          debugPrint('Error parsing SignalR data: $e\n$s');
        }
      }
    });

    await _hubConnection.start();
    debugPrint('SignalR connected.');

    // Подписка на группу и запрос статусов
    await _hubConnection.invoke("Subscribe", args: [nameId]);
    debugPrint("✅ Subscribed to group with nameId: $nameId");

    await _hubConnection.invoke("RequestStatus", args: [nameId]);
    debugPrint("✅ Requested initial status for nameId: $nameId");
  }

  @override
  void dispose() {
    debugPrint('Disposing ActiveOrderPage...');
    _hubConnection.stop();
    if (!_isControllerClosed) {
      _controller.close();
      _isControllerClosed = true;
    }
    debugPrint('Resources released.');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.activeOrders)),
      body: BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
        builder: (context, state) {
          debugPrint('Current ActiveOrderCubit state: $state');
          if (state is ActiveOrdersError) {
            return EmptyActiveOrders(text: context.l10n.errorLoadingActiveOrders);
          } else if (state is ActiveOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ActiveOrdersLoaded) {
            orders = state.orders;
            debugPrint('Orders loaded: ${orders.length}');
            if (orders.isEmpty) {
              _hubConnection.stop();
              return EmptyActiveOrders(text: context.l10n.noActiveOrders);
            }
          }

          return StreamBuilder<List<OrderStatusEntity>>(
            stream: _controller.stream,
            builder: (context, snapshot) {
              debugPrint('StreamBuilder snapshot state: $snapshot');
              if (snapshot.hasError) {
                debugPrint('Stream error: ${snapshot.error}');
                return Center(child: Text(context.l10n.errorRetrievingData));
              } else if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final orderStatuses = snapshot.data!;
              debugPrint('Order statuses in UI: $orderStatuses');

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: orders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final orderNumber = order.orderNumber;
                  if (orderNumber == null) {
                    return const SizedBox.shrink();
                  }
                  OrderStatusEntity? statusFromSignalR = orderStatuses.firstWhereOrNull(
                    (element) => element.orderNumber == orderNumber,
                  );
                  final orderStatus = statusFromSignalR ??
                      OrderStatusEntity(
                        orderNumber: orderNumber,
                        status: order.status ?? context.l10n.unknown,
                      );

                  debugPrint('Order $orderNumber with status: [33m${orderStatus.status}[0m');

                  return Card(
                    child: ListTile(
                      shape: const Border(
                        bottom: BorderSide(color: Colors.transparent),
                      ),
                      title: Text(
                        '${context.l10n.orderNumber} $orderNumber',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          OrderStepper(orderStatus: orderStatus),
                          CustomTextButton(
                            textStyle: theme.textTheme.bodyLarge!.copyWith(color: AppColors.primary),
                            onPressed: () => context.pushRoute(
                              OrderDetailRoute(orderNumber: "$orderNumber"),
                            ),
                            textButton: context.l10n.orderDetails,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
