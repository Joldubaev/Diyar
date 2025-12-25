import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Контент bottom sheet с QR кодом
class BonusQrSheetContent extends StatelessWidget {
  const BonusQrSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BonusCubit, BonusState>(
      builder: (context, state) {
        if (state is BonusQrLoading) {
          return const _LoadingState();
        }

        if (state is BonusQrFailure) {
          return const _QrNotAvailableWidget();
        }

        if (state is BonusQrLoaded) {
          return _QrContent(qrData: state.qrData);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// Контент с QR кодом
class _QrContent extends StatelessWidget {
  final QrGenerateEntity qrData;

  const _QrContent({required this.qrData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final token = qrData.token;

    if (token == null || token.isEmpty) {
      return const _QrNotAvailableWidget();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Мой QR код',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Покажите QR код официанту для получения бонусов',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          QrCodeDisplay(data: token),
          const SizedBox(height: 32),
          Text(
            'Скопируйте код ниже:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CopyableTokenField(token: token),
        ],
      ),
    );
  }
}

/// Виджет состояния загрузки
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

/// Виджет для отображения, когда QR код недоступен
class _QrNotAvailableWidget extends StatelessWidget {
  const _QrNotAvailableWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.qr_code_scanner_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            'QR код недоступен',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Пожалуйста, попробуйте позже',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
