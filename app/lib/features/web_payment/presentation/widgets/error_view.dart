import 'package:diyar/features/web_payment/presentation/constants/web_payment_strings.dart';
import 'package:flutter/material.dart';

class WebPaymentErrorView extends StatelessWidget {
  const WebPaymentErrorView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(WebPaymentStrings.buttonBack),
            ),
          ],
        ),
      ),
    );
  }
}
