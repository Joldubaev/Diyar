import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Поле с токеном и функцией копирования
class CopyableTokenField extends StatelessWidget {
  final String token;

  const CopyableTokenField({
    super.key,
    required this.token,
  });

  Future<void> _copyToken(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: token));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Код скопирован'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              token,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _copyToken(context),
            icon: Icon(
              Icons.copy_rounded,
              color: AppColors.primary,
              size: 24,
            ),
            tooltip: 'Копировать',
          ),
        ],
      ),
    );
  }
}
