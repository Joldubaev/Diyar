import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BonusCardWidget extends StatelessWidget {
  /// Если передан — карточка рисуется из этих данных (главная через HomeContentCubit).
  /// Иначе — из ProfileCubit.
  final UserProfileModel? profile;

  const BonusCardWidget({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    if (!UserHelper.isAuth()) {
      return _buildGuestContent(context);
    }

    if (profile != null) {
      return _buildContent(
        context,
        balance: (profile!.balance ?? 0.0).toDouble(),
        discount: profile!.discount ?? 0,
      );
    }

    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is ProfileGetLoaded,
      builder: (context, state) {
        if (state is! ProfileGetLoaded) {
          return const SizedBox.shrink();
        }
        final user = state.userModel;
        return _buildContent(
          context,
          balance: (user.balance ?? 0.0).toDouble(),
          discount: user.discount ?? 0,
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required double balance,
    required int discount,
  }) {
    return BonusCardBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ваш баланс',
            style: TextStyle(
              fontSize: 14,
              color: context.colorScheme.onSurface,
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
  }

  Widget _buildGuestContent(BuildContext context) {
    return BonusCardBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ваш баланс',
            style: TextStyle(
              fontSize: 14,
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BonusValueText(balance: 0),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Войдите и начните\nполучать кэшбэк',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _GuestLoginButton(),
        ],
      ),
    );
  }
}

class _GuestLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surface.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: () => showRegistrationAlertDialog(context),
        borderRadius: BorderRadius.circular(999),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Text(
            'Войти',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
