import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/payments/payments.dart';
import 'package:diyar/features/payments/presentation/widgets/error_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MbankCheckStatusPage extends StatefulWidget {
  final double amount;
  final String? orderNumber;
  const MbankCheckStatusPage({super.key, required this.amount, this.orderNumber});

  @override
  State<MbankCheckStatusPage> createState() => _MbankCheckStatusPageState();
}

class _MbankCheckStatusPageState extends State<MbankCheckStatusPage> {
  @override
  void initState() {
    super.initState();
    if (widget.orderNumber != null) {
      context.read<PaymentBloc>().add(CheckMbankStatusEvent(widget.orderNumber!));
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
            if (state is PaymentMbankLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PaymentMbankStatusSuccess) {
              return SuccessStatusWidget(
                amount: widget.amount,
                path: 'assets/icons/succes.svg',
              );
            }
            if (state is PaymentMbankError) {
              return ErrorStatusWidget(
                message: state.message,
                type: state.status,
                onRetry: () {
                  context.read<PaymentBloc>().add(CheckMbankStatusEvent(widget.orderNumber!));
                },
              );
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
