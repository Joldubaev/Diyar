import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Компонент для отображения QR кода
class QrCodeDisplay extends StatelessWidget {
  final String data;

  const QrCodeDisplay({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: 280,
        backgroundColor: Colors.white,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
