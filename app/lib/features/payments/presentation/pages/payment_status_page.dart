import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:diyar/features/payments/presentation/widgets/payment_status_widget.dart';
import 'package:diyar/features/payments/presentation/enum/payment_status_type.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
  PaymentStatusType _status = PaymentStatusType.pending;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initSignalR();
  }

  Future<void> _initSignalR() async {
    final hubUrl = 'http://20.127.235.82/api/payment-status-hub';
    _hubConnection = HubConnectionBuilder().withUrl(hubUrl).build();

    _hubConnection.on("ReceiveStatus", (data) {
      debugPrint('SignalR: Получены статусы: $data');
      if (data != null && data.isNotEmpty) {
        final List<dynamic> list = data;
        debugPrint('SignalR: Количество заказов в ответе: ${list.length}');
        for (var i = 0; i < list.length; i++) {
          final item = list[i];
          debugPrint('SignalR: Заказ #$i:');
          if (item is Map) {
            item.forEach((key, value) {
              debugPrint('  $key: $value');
            });
          } else {
            debugPrint('  $item');
          }
        }
        final order = list.firstWhere(
          (json) => json['orderNumber'].toString() == widget.orderNumber.toString(),
          orElse: () => null,
        );
        debugPrint('SignalR: Найден order: $order');
        setState(() {
          if (order != null) {
            // Универсальный парсинг статуса (строка или число)
            final mapOrder = Map<String, dynamic>.from(order);
            String statusValue = mapOrder['status']?.toString() ?? mapOrder['orderStatus']?.toString() ?? '';
            debugPrint('SignalR: Статус заказа (универсально): $statusValue');
            _status = PaymentStatusTypeMapper.fromCode(statusValue);
            debugPrint('SignalR: Статус для orderNumber ${widget.orderNumber}: $statusValue => [32m$_status[0m');
          } else {
            _status = PaymentStatusType.pending;
            debugPrint('SignalR: Статус не найден, выставлен pending');
          }
          _loading = false;
        });
      } else {
        setState(() {
          _status = PaymentStatusType.pending;
          _loading = false;
          debugPrint('SignalR: Данных нет, выставлен pending');
        });
      }
    });

    // Получаем nameId из токена
    final token = sl<LocalStorage>().getString(AppConst.accessToken);
    debugPrint('SignalR: accessToken: $token');
    String? nameId;
    if (token != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      debugPrint('SignalR: decodedToken: $decodedToken');
      nameId = decodedToken['nameid']?.toString();
      debugPrint('SignalR: nameId: $nameId');
    }
    await _hubConnection.start();
    debugPrint('SignalR: Соединение установлено');
    if (widget.orderNumber.isNotEmpty) {
      final wi = int.parse(widget.orderNumber);
      await _hubConnection.invoke("Subscribe", args: [wi]);
      debugPrint('SignalR: Подписка на ordernumber: $wi');
    } else {
      debugPrint('SignalR: Не удалось получить ordernumber для подписки!');
    }
    try {
      final wi = int.parse(widget.orderNumber);
      await _hubConnection.invoke("RequestStatus", args: [wi]);
      debugPrint('SignalR: Запрошен статус для orderNumber: $wi');
    } catch (e, s) {
      debugPrint('SignalR: Ошибка при вызове RequestStatus: $e\n$s');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при получении статуса заказа: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Статус платежа'),
      ),
      body: Center(
        child: PaymentStatusWidget(
          status: _status,
          amount: widget.amount,
          title: _status.title,
          buttonText: 'Готово',
          onButtonTap: _status == PaymentStatusType.success ? () => context.pushRoute(MainRoute()) : null,
        ),
      ),
    );
  }
}
