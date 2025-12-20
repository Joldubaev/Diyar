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
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    // Генерируем QR код через qr_flutter из данных, полученных с сервера
    // qrData.qrData содержит URL, который нужно закодировать в QR
    if (qrData.qrData == null || qrData.qrData!.isEmpty) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Генерация QR кода через qr_flutter
          QrImageView(
            data: qrData.qrData!, // URL для кодирования в QR
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            errorCorrectionLevel: QrErrorCorrectLevel.M,
            padding: const EdgeInsets.all(8),
          ),
          if (qrData.expiresAt != null) ...[
            const SizedBox(height: 16),
            Text(
              'QR код действителен до',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              '${qrData.expiresAt}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
