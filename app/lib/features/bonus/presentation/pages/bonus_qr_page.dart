import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/bonus/bonus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BonusQrPage extends StatelessWidget {
  const BonusQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мой QR')),
      body: BlocBuilder<BonusCubit, BonusState>(
        builder: (context, state) {
          return animatedSwitcher(
            child: switch (state) {
              BonusInitial() || BonusQrLoading() => const _LoadingView(),
              BonusQrFailure(message: final msg) => _ErrorView(message: msg),
              BonusQrLoaded(qrData: final data) => _SuccessView(qrData: data),
            },
          );
        },
      ),
    );
  }

  Widget animatedSwitcher({required Widget child}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator.adaptive());
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.read<BonusCubit>().generateQr(),
            child: const Text('Попробовать снова'),
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final QrGenerateEntity qrData;
  const _SuccessView({required this.qrData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: Column(
          children: [
            QrCodeWidget(qrData: qrData),
            const SizedBox(height: 32),
            Text(
              'Покажите этот QR код официанту',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            _InfoBadge(text: 'QR код обновляется каждые 10 минут'),
            const SizedBox(height: 48),
            OutlinedButton.icon(
              onPressed: () => context.read<BonusCubit>().generateQr(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Обновить сейчас'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String text;
  const _InfoBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
    );
  }
}
