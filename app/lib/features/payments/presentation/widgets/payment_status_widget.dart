import 'package:diyar/features/payments/payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaymentStatusWidget extends StatelessWidget {
  final PaymentStatusType status;
  final double amount;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const PaymentStatusWidget({
    super.key,
    required this.status,
    required this.amount,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    Color iconBg;

    switch (status) {
      case PaymentStatusType.success:
        color = Colors.green;
        iconBg = Colors.green.withValues(alpha: 0.15);
        break;
      case PaymentStatusType.pending:
        color = Colors.grey;
        iconBg = Colors.grey.withValues(alpha: 0.15);
        break;
      case PaymentStatusType.error:
        color = Colors.red;
        iconBg = Colors.red.withValues(alpha: 0.15);
        break;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/${status == PaymentStatusType.success ? 'check' : status == PaymentStatusType.pending ? 'pending' : 'error'}.svg',
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                  height: 50,
                ),
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                children: [
                  const TextSpan(text: '- '),
                  TextSpan(
                    text: amount.toStringAsFixed(0),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' сом',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const Spacer(flex: 3),
            if (buttonText != null && onButtonTap != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: onButtonTap,
                  child: Text(
                    buttonText!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
