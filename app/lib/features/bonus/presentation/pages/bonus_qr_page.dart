import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/bonus/bonus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BonusQrPage extends StatefulWidget {
  const BonusQrPage({super.key});

  @override
  State<BonusQrPage> createState() => _BonusQrPageState();
}

class _BonusQrPageState extends State<BonusQrPage> {
  @override
  void initState() {
    super.initState();
    context.read<BonusCubit>().generateQr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой QR'),
      ),
      body: BlocBuilder<BonusCubit, BonusState>(
        builder: (context, state) {
          if (state is BonusQrLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BonusQrFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки QR кода',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<BonusCubit>().generateQr(),
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            );
          }

          if (state is BonusQrLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  QrCodeWidget(qrData: state.qrData),
                  const SizedBox(height: 32),
                  Text(
                    'Покажите этот QR код официанту',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'QR код обновляется каждые 10 минут',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => context.read<BonusCubit>().generateQr(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Обновить QR код'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
