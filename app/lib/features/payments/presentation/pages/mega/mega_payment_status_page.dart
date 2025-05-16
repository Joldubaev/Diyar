import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/payments/payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MegaPaymentStatusPage extends StatefulWidget {
  final double amount;
  final String? orderNumber;
  const MegaPaymentStatusPage({super.key, required this.amount, this.orderNumber});

  @override
  State<MegaPaymentStatusPage> createState() => _MegaPaymentStatusPageState();
}

class _MegaPaymentStatusPageState extends State<MegaPaymentStatusPage> {
  @override
  void initState() {
    super.initState();
    if (widget.orderNumber != null) {
      context.read<PaymentBloc>().add(CheckPaymentStatusEvent(widget.orderNumber!));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        centerTitle: true,
        leading: const BackButton(),
        elevation: 0,
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PaymentStatusSuccess) {
            return SuccessStatusWidget(
              amount: widget.amount,
              path: 'assets/icons/succes.svg',
            );
          }
          if (state is PaymentError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
