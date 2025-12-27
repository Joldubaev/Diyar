import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:diyar/features/bonus/domain/entities/qr_generate_entity.dart';

/// Виджет для отображения QR кода, генерируемого через qr_flutter
class QrCodeWidget extends StatelessWidget {
  final QrGenerateEntity qrData;
  final double size;

  const QrCodeWidget({
    super.key,
    required this.qrData,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    final token = qrData.token;

    if (token == null || token.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'QR данные отсутствуют',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Генерация QR кода через qr_flutter (только токен)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 2,
              ),
            ],
          ),
          child: QrImageView(
            data: token,
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 24),
        // Отображение кода токена
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            token,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.black87,
                ),
          ),
        ),
        if (qrData.expiresAt != null) ...[
          const SizedBox(height: 16),
          Text(
            'QR код действителен до ${qrData.expiresAt}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
