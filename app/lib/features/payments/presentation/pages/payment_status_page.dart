import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:diyar/features/payments/presentation/widgets/payment_status_widget.dart';
import 'package:diyar/features/payments/presentation/enum/payment_status_type.dart';

@RoutePage()
class PaymentStatusPage extends StatefulWidget {
  final double amount;
  final String orderNumber;
  const PaymentStatusPage({
    super.key,
    required this.amount,
    required this.orderNumber,
  });

  @override
  State<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage> {
  late final HubConnection _hubConnection;
  PaymentStatusType? _status;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initSignalR();
  }

  Future<void> _initSignalR() async {
    _hubConnection = HubConnectionBuilder().withUrl("http://20.127.235.82/api/payment-status-hub").build();

    _hubConnection.on("ReceiveStatus", (data) {
      if (data != null && data.isNotEmpty) {
        final List<dynamic> list = data;
        final order = list.firstWhere(
          (json) => json['orderNumber'] == widget.orderNumber,
          orElse: () => null,
        );
        if (order != null) {
          final status = PaymentStatusTypeMapper.fromCode(order['status']);
          setState(() {
            _status = status;
            _loading = false;
          });
        }
      }
    });

    await _hubConnection.start();
    await _hubConnection.invoke("Subscribe", args: [widget.orderNumber]);
    await _hubConnection.invoke("RequestStatus", args: [widget.orderNumber]);
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _status == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статус платежа'),
      ),
      body: Center(
        child: PaymentStatusWidget(
          status: _status!,
          amount: widget.amount,
          title: _status!.title,
          buttonText: 'Готово',
          onButtonTap: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
