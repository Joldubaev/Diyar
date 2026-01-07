import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет бонусной карты для главной страницы
class BonusCardWidget extends StatelessWidget {
  const BonusCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!UserHelper.isAuth()) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is ProfileGetLoaded,
      builder: (context, state) {
        if (state is! ProfileGetLoaded) {
          return const SizedBox.shrink();
        }

        final user = state.userModel;
        final balance = (user.balance ?? 0).toInt();
        final discount = user.discount ?? 0;

        return BonusCardBackground(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _CardInfoColumn(
                  balance: balance,
                  discount: discount,
                ),
              ),
              const SizedBox(width: 16),
              _QrActionButton(
                onPressed: () => BonusSheetHandler.show(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Колонка с информацией о балансе и скидке
class _CardInfoColumn extends StatelessWidget {
  final int balance;
  final int discount;

  const _CardInfoColumn({
    required this.balance,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ваш баланс',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        BonusValueText(balance: balance),
        const SizedBox(height: 16),
        DiscountBadge(discount: discount),
      ],
    );
  }
}

/// Кнопка для открытия QR кода
class _QrActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _QrActionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      icon: const Icon(
        Icons.qr_code_2_rounded,
        color: Color(0xFF1E8449),
        size: 22,
      ),
      label: const Text(
        'Мой QR',
        style: TextStyle(
          color: Color(0xFF1E8449),
          fontWeight: FontWeight.w600,
          fontSize: 15,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
