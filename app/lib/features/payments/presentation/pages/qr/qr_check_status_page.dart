import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyar/features/payments/presentation/bloc/payment_bloc.dart';
import 'package:diyar/features/payments/presentation/widgets/payment_status_widget.dart';
import 'package:diyar/features/payments/presentation/enum/payment_status_mapper.dart';
import 'package:diyar/features/payments/presentation/enum/paymethod_enum.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/payments/presentation/enum/payment_status_type.dart';

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
    _checkStatus();
  }

  void _checkStatus() {
    context.read<PaymentBloc>().add(
          CheckQrCodeStatusEvent(widget.transactionId, widget.orderNumber),
        );
  }

  void _goToMain() {
    context.router.pushAndPopUntil(const MainRoute(), predicate: (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статус платежа'),
        centerTitle: true,
        leading: const BackButton(),
        elevation: 0,
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentQrCodeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PaymentQrCodeStatusSuccess) {
            final status = PaymentStatusMapper.fromCode(state.status.code);
            final isSuccess = status == PaymentStatusEnum.success;
            return Center(
              child: PaymentStatusWidget(
                status: status.toPaymentStatusType(),
                amount: widget.amount,
                title: PaymentStatusMapper.message(status, state.status.message),
                buttonText: isSuccess ? 'Готово' : 'Проверить ещё раз',
                onButtonTap: isSuccess ? _goToMain : _checkStatus,
              ),
            );
          }
          if (state is PaymentError) {
            return Center(
              child: PaymentStatusWidget(
                status: PaymentStatusEnum.unknown.toPaymentStatusType(),
                amount: widget.amount,
                title: state.message,
                buttonText: 'Проверить ещё раз',
                onButtonTap: _checkStatus,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

extension PaymentStatusEnumX on PaymentStatusEnum {
  PaymentStatusType toPaymentStatusType() {
    switch (this) {
      case PaymentStatusEnum.success:
        return PaymentStatusType.success;
      case PaymentStatusEnum.pending:
        return PaymentStatusType.pending;
      case PaymentStatusEnum.failed:
        return PaymentStatusType.error;
      default:
        return PaymentStatusType.error;
    }
  }
}
