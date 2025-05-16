import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/payments/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class PaymentsPage extends StatelessWidget {
  final String? orderNumber;
  final String? amount;
  const PaymentsPage({
    super.key,
    this.orderNumber,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Выберите способ оплаты',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 24),
            PaymentMethodTileWidget(
              icon: SvgPicture.asset('assets/icons/mbank.svg', height: 28),
              title: 'Mbank',
              onTap: () => context.router.push(MbankInitiateRoute(
                amount: amount ?? '0',
                orderNumber: orderNumber ?? '0',
              )),
            ),
            PaymentMethodTileWidget(
              icon: SvgPicture.asset('assets/icons/mega.svg', height: 28),
              title: 'Megapay',
              onTap: () => context.router.push(MegaCheckUserRoute(
                amount: amount ?? '0',
                orderNumber: orderNumber ?? '0',
              )),
            ),
            PaymentMethodTileWidget(
              icon: SvgPicture.asset('assets/icons/qr_code.svg', height: 28),
              title: 'Оплата через QR',
              onTap: () => context.router.push(QrCodeRoute(
                initialAmount: int.parse(amount ?? '0'),
                orderNumber: orderNumber ?? '0',
              )),
            ),
          ],
        ),
      ),
    );
  }
}
