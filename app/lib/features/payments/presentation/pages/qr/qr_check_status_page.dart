import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyar/features/payments/presentation/bloc/payment_bloc.dart';
import 'package:diyar/features/payments/presentation/widgets/succes_status_widget.dart';
import 'package:diyar/features/payments/presentation/widgets/error_status_widget.dart';
import 'package:diyar/features/payments/presentation/enum/payment_status_mapper.dart';
import 'package:diyar/features/payments/presentation/enum/paymethod_enum.dart';

@RoutePage()
class QrCheckStatusPage extends StatefulWidget {
  final String transactionId;
  final String orderNumber;
  final double amount;

  const QrCheckStatusPage({
    super.key,
    required this.transactionId,
    required this.orderNumber,
    required this.amount,
  });

  @override
  State<QrCheckStatusPage> createState() => _QrCheckStatusPageState();
}

class _QrCheckStatusPageState extends State<QrCheckStatusPage> {
  @override
  void initState() {
    super.initState();
    // Отправляем событие проверки статуса QR-платежа
    context.read<PaymentBloc>().add(
          CheckQrCodeStatusEvent(widget.transactionId, widget.orderNumber),
        );
  }

  void _checkStatus() {
    context.read<PaymentBloc>().add(
          CheckQrCodeStatusEvent(widget.transactionId, widget.orderNumber),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статус оплаты'),
        centerTitle: true,
        leading: const BackButton(),
        elevation: 0,
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentQrCodeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is PaymentQrCodeStatusSuccess) {
            final status = PaymentStatusMapper.fromCode(
              state.status.code,
            );
            if (status == PaymentStatusEnum.success) {
              return SuccessStatusWidget(
                amount: widget.amount,
                path: 'assets/icons/succes.svg',
              );
            }

            if (status == PaymentStatusEnum.pending) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      PaymentStatusMapper.message(status),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _checkStatus,
                      child: const Text('Проверить ещё раз'),
                    ),
                  ],
                ),
              );
            }

            return ErrorStatusWidget(
              type: status,
              message: PaymentStatusMapper.message(status, state.status.message),
              onRetry: _checkStatus,
            );
          }

          if (state is PaymentError) {
            return ErrorStatusWidget(
              type: PaymentStatusEnum.unknown,
              message: state.message,
              onRetry: _checkStatus,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
