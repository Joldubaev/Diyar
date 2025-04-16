import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/constants/constant.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/injection_container.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

@RoutePage()
class ActiveOrderPage extends StatefulWidget {
  const ActiveOrderPage({super.key});

  @override
  State<ActiveOrderPage> createState() => _ActiveOrderPageState();
}

class _ActiveOrderPageState extends State<ActiveOrderPage> {
  List<ActiveOrderModel> orders = [];
  late final IOWebSocketChannel _channel;
  final StreamController<List<OrderStatusModel>> _controller =
      StreamController.broadcast();
  bool _isControllerClosed = false;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    context.read<HistoryCubit>().getActiveOrders();
    debugPrint('ActiveOrderPage initialized.');
  }

  void _initializeWebSocket() async {
    var token = sl<SharedPreferences>().getString(AppConst.accessToken);
    debugPrint('Access Token: $token');
    if (token == null) {
      debugPrint('No token found.');
      return;
    }

    _channel = IOWebSocketChannel.connect(
        'ws://176.126.164.230:8088/ws/get-status-with-websocket?token=$token');
    debugPrint('WebSocket connected.');

    _channel.stream.listen((data) {
      debugPrint('Data received from WebSocket: $data');
      if (!_isControllerClosed) {
        try {
          final List<dynamic> jsonData = jsonDecode(data as String);
          final List<OrderStatusModel> orderStatuses = jsonData
              .map((dynamic json) => OrderStatusModel.fromJson(json))
              .toList();
          _controller.add(orderStatuses);
          debugPrint('Order statuses updated.');
        } catch (e) {
          debugPrint('Error parsing WebSocket data: $e');
        }
      }
    }, onError: (error) {
      debugPrint('WebSocket error: $error');
      if (!_isControllerClosed) {
        _controller.addError(error);
      }
    }, onDone: () {
      debugPrint('WebSocket closed.');
      if (!_isControllerClosed) {
        _controller.close();
        _isControllerClosed = true;
      }
    });
  }

  @override
  void dispose() {
    debugPrint('Disposing ActiveOrderPage...');
    _channel.sink.close();
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
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          debugPrint('Current HistoryCubit state: $state');
          if (state is GetActiveOrdersError) {
            return EmptyActiveOrders(
                text: context.l10n.errorLoadingActiveOrders);
          } else if (state is GetActiveOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetActiveOrdersLoaded) {
            orders = state.orders;
            debugPrint('Orders loaded: ${orders.length}');
            if (orders.isEmpty) {
              _channel.sink.close();
              return EmptyActiveOrders(text: context.l10n.noActiveOrders);
            }
          }

          return StreamBuilder<List<OrderStatusModel>>(
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
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final orderNumber = order.order?.orderNumber;
                  final orderStatus = orderStatuses.firstWhere(
                    (element) => element.orderNumber == orderNumber,
                    orElse: () => OrderStatusModel(
                        orderNumber: orderNumber!,
                        status: context.l10n.unknown),
                  );

                  debugPrint(
                      'Order $orderNumber with status: ${orderStatus.status}');

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
                              textStyle: theme.textTheme.bodyLarge!
                                  .copyWith(color: AppColors.primary),
                              onPressed: () => context.pushRoute(
                                OrderDetailRoute(orderNumber: "$orderNumber"),
                              ),
                              textButton: context.l10n.orderDetails,
                            ),
                          ],
                        )),
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
