import 'package:diyar/features/payments/payments.dart';
import 'package:flutter/material.dart';
import 'check_painter_widget.dart';

class PaymentStatusWidget extends StatefulWidget {
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
  State<PaymentStatusWidget> createState() => _PaymentStatusWidgetState();
}

class _PaymentStatusWidgetState extends State<PaymentStatusWidget> with SingleTickerProviderStateMixin {
  late AnimationController _loadingController;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color iconBg;
    PaymentStatusType status = widget.status;

    switch (status) {
      case PaymentStatusType.success:
        iconBg = Colors.green;
        break;
      case PaymentStatusType.pending:
        iconBg = Colors.grey;
        break;
      case PaymentStatusType.error:
        iconBg = Colors.red;
        break;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Spacer(flex: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: status == PaymentStatusType.pending
                    ? AnimatedBuilder(
                        animation: _loadingController,
                        builder: (context, child) {
                          return CustomPaint(
                            size: const Size(60, 60),
                            painter: LoadingPainter(
                              progress: _loadingController.value,
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                    : TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return CustomPaint(
                            size: const Size(60, 60),
                            painter: status == PaymentStatusType.success
                                ? CheckmarkPainter(
                                    progress: value,
                                    color: Colors.white,
                                  )
                                : ErrorPainter(
                                    progress: value,
                                    color: Colors.white,
                                  ),
                          );
                        },
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
                    text: widget.amount.toStringAsFixed(0),
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
              widget.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                widget.subtitle!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const Spacer(flex: 3),
            if (widget.buttonText != null && widget.onButtonTap != null)
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
                  onPressed: widget.onButtonTap,
                  child: Text(
                    widget.buttonText!,
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
