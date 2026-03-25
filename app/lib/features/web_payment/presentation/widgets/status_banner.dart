import 'package:diyar/core/core.dart';
import 'package:diyar/features/web_payment/domain/enum/payment_status_type.dart';
import 'package:diyar/features/web_payment/presentation/constants/web_payment_strings.dart';
import 'package:flutter/material.dart';

class WebPaymentStatusBanner extends StatelessWidget {
  const WebPaymentStatusBanner({super.key, required this.status});

  final PaymentStatusType status;

  @override
  Widget build(BuildContext context) {
    final isError = status == PaymentStatusType.error;
    final colorScheme = context.colorScheme;

    return Material(
      color: isError ? colorScheme.errorContainer : colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            if (isError)
              Icon(Icons.error_outline, color: colorScheme.onErrorContainer)
            else
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isError ? status.title : WebPaymentStrings.statusWaiting,
                style: TextStyle(
                  color: isError ? colorScheme.onErrorContainer : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
