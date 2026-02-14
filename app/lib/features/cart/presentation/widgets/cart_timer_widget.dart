import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/settings/domain/entities/timer_entites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет для отображения состояния таймера и кнопки подтверждения заказа
class CartTimerWidget extends StatelessWidget {
  final VoidCallback? onConfirm;
  final String confirmButtonTitle;

  const CartTimerWidget({
    super.key,
    this.onConfirm,
    required this.confirmButtonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state is TimerLoading) {
          return _buildLoading();
        }

        if (state is TimerError) {
          return _buildError(context, state.message);
        }

        if (state is TimerLoaded) {
          return _buildConfirmButton(context, state.timer);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoading() {
    return const SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String errorMessage) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            errorMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, TimerEntites? timer) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      sliver: SliverToBoxAdapter(
        child: SubmitButtonWidget(
          textStyle: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
          bgColor: theme.colorScheme.primary,
          title: confirmButtonTitle,
          onTap: () => _handleConfirm(context, timer),
        ),
      ),
    );
  }

  void _handleConfirm(BuildContext context, TimerEntites? timer) {
    if (timer?.serverTime == null) {
      SnackBarMessage().showErrorSnackBar(
        message: "Не удалось получить актуальное время работы магазина. Попробуйте позже.",
        context: context,
      );
      return;
    }

    onConfirm?.call();
  }
}
