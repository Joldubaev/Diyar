import 'package:diyar/features/payments/presentation/presentation.dart';
import 'package:flutter/material.dart';

class ErrorStatusWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final PaymentStatusEnum type;

  const ErrorStatusWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.type = PaymentStatusEnum.unknown,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case PaymentStatusEnum.success:
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case PaymentStatusEnum.pending:
        icon = Icons.hourglass_empty;
        color = Colors.blue;
        break;
      case PaymentStatusEnum.badRequest:
        icon = Icons.error_outline;
        color = Colors.orange;
        break;
      case PaymentStatusEnum.insufficientFunds:
        icon = Icons.account_balance_wallet_outlined;
        color = Colors.red;
        break;
      case PaymentStatusEnum.userBlocked:
        icon = Icons.block;
        color = Colors.red;
        break;
      case PaymentStatusEnum.notFound:
        icon = Icons.cancel_outlined;
        color = Colors.red;
        break;
      case PaymentStatusEnum.accessDenied:
        icon = Icons.lock_outline;
        color = Colors.red;
        break;
      case PaymentStatusEnum.otpError:
        icon = Icons.security;
        color = Colors.orange;
        break;
      case PaymentStatusEnum.limitExceeded:
        icon = Icons.speed;
        color = Colors.red;
        break;
      case PaymentStatusEnum.internalError:
        icon = Icons.cloud_off;
        color = Colors.red;
        break;
      case PaymentStatusEnum.failed:
        icon = Icons.cancel_outlined;
        color = Colors.red;
        break;
      case PaymentStatusEnum.alreadyExists:
        icon = Icons.info_outline;
        color = Colors.amber;
        break;
      case PaymentStatusEnum.unknown:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 56),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ],
      ),
    );
  }
}
