import 'package:flutter/material.dart';

class ErrorWithRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorWithRetry({required this.message, required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('Повторить'),
          ),
        ],
      ),
    );
  }
}