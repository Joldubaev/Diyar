
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SuccessStatusWidget extends StatelessWidget {
  final double amount;
  final String path;
  const SuccessStatusWidget({
    super.key,
    required this.amount,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  path,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Готово',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                children: [
                  const TextSpan(text: '- '),
                  TextSpan(
                    text: amount.toStringAsFixed(0),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' сом',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Платеж осуществлен',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Скоро ваш заказ будет у вас!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            SubmitButtonWidget(
              title: 'Готово',
              bgColor: theme.primaryColor,
              onTap: () => context.router.pushAndPopUntil(
                const MainRoute(),
                predicate: (_) => false,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
