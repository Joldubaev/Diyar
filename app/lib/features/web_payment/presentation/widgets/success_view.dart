import 'package:diyar/features/web_payment/domain/enum/payment_status_type.dart';
import 'package:diyar/features/web_payment/presentation/constants/web_payment_strings.dart';
import 'package:diyar/features/web_payment/presentation/cubit/open_banking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebPaymentSuccessView extends StatelessWidget {
  const WebPaymentSuccessView({super.key, required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = PaymentStatusType.success;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, size: 48, color: theme.colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 24),
            Text(
              '- $amount сом',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Text(
              status.title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.read<OpenBankingCubit>().onPaymentConfirmed(),
                child: const Text(WebPaymentStrings.buttonDone),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
