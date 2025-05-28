import 'dart:async';
import 'dart:developer';

import 'package:diyar/core/core.dart';
import 'package:diyar/features/payments/payments.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MbankConfirmPage extends StatefulWidget {
  final String? phone;
  final double? amount;
  final String? orderNumber;
  final String? paymentId;

  const MbankConfirmPage({
    super.key,
    this.phone,
    this.amount,
    this.orderNumber,
    this.paymentId,
  });

  @override
  State<MbankConfirmPage> createState() => _MbankConfirmPageState();
}

class _MbankConfirmPageState extends State<MbankConfirmPage> {
  Timer? _timer;
  int _start = 59;
  bool isTimeEnd = false;
  String enteredCode = "";

  String get formattedPhone {
    String phone = widget.phone ?? '';
    if (phone.length >= 12) {
      return '+${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6, 9)} ${phone.substring(9)}';
    }
    return phone;
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 1) {
          setState(() {
            timer.cancel();
            isTimeEnd = true;
          });
        } else {
          setState(() {
            isTimeEnd = false;
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentMbankError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is PaymentMbankSuccess) {
          context.router.push(
            PaymentStatusRoute(
              amount: widget.amount ?? 0,
              orderNumber: widget.orderNumber.toString(),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Введите код',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Введите код который мы отправили на номер который вы ввели',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 32),
                Pinput(
                  length: 4,
                  onChanged: (value) {
                    setState(() => enteredCode = value);
                  },
                  onCompleted: (value) => setState(() => enteredCode = value),
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 70,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Spacer(),
                SubmitButtonWidget(
                  bgColor: theme.primaryColor,
                  textStyle: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                  title: 'Подтвердить',
                  onTap: () {
                    if (enteredCode.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Введите код')),
                      );
                      return;
                    }
                    log('enteredCode: $enteredCode');
                    final entity = PaymentsEntity(
                      orderNumber: widget.paymentId,
                      otp: enteredCode,
                    );
                    context.read<PaymentBloc>().add(ConfirmMbankEvent(entity));
                  },
                  height: 55,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
