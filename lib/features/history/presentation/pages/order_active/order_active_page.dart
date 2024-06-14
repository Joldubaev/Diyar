import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/history/data/model/order_status_model.dart';
import 'package:diyar/features/history/history.dart';
import 'package:diyar/features/order/presentation/widgets/order_stepper.dart';
import 'package:diyar/injection_container.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

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
  }

  void _initializeWebSocket() async {
    var token = sl<SharedPreferences>().getString(AppConst.accessToken);
    if (token == null) return;

    _channel = IOWebSocketChannel.connect(
        'ws://176.126.164.230:8088/ws/get-status-with-websocket?token=$token');

    _channel.stream.listen((data) {
      if (!_isControllerClosed) {
        final List<dynamic> jsonData = jsonDecode(data as String);
        final List<OrderStatusModel> orderStatuses = jsonData
            .map((dynamic json) => OrderStatusModel.fromJson(json))
            .toList();
        _controller.add(orderStatuses);
      }
    }, onError: (error) {
      if (!_isControllerClosed) {
        _controller.addError(error);
      }
    }, onDone: () {
      if (!_isControllerClosed) {
        _controller.close();
        _isControllerClosed = true;
      }
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    if (!_isControllerClosed) {
      _controller.close();
      _isControllerClosed = true;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is GetActiveOrdersError) {
          return const EmptyActiveOrders();
        } else if (state is GetActiveOrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetActiveOrdersLoaded) {
          orders = state.orders;
          if (orders.isEmpty) {
            _channel.sink.close();
            return const EmptyActiveOrders();
          }
        }

        return StreamBuilder<List<OrderStatusModel>>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Ошибка при получении данных.'));
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final orderStatuses = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = orders[index];
                final orderNumber = order.order?.orderNumber;
                final orderStatus = orderStatuses.firstWhere(
                  (element) => element.orderNumber == orderNumber,
                  orElse: () => OrderStatusModel(
                      orderNumber: orderNumber!, status: 'Unknown'),
                );

                return Card(
                  child: ExpansionTile(
                    shape: const Border(
                      bottom: BorderSide(color: Colors.transparent),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                    title: Text(
                      '${context.l10n.orderNumber} $orderNumber',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    children: [
                      OrderStepper(orderStatus: orderStatus),
                      CustomTextButton(
                        onPressed: () => context.pushRoute(
                          OrderDetailRoute(orderNumber: "$orderNumber"),
                        ),
                        textButton: context.l10n.orderDetails,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
