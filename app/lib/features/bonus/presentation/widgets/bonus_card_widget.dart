import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final balance = (user.balance ?? 0.0).toDouble();
        final discount = user.discount ?? 0;

        return BonusCardBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ваш баланс',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BonusValueText(balance: balance),
                  DiscountBadge(discount: discount),
                ],
              ),
              const SizedBox(height: 16),
              BonusCardButton(
                onPressed: () => BonusSheetHandler.show(context),
                icon: Icons.qr_code_2_rounded,
                label: 'Мой QR',
              ),
            ],
          ),
        );
      },
    );
  }
}
