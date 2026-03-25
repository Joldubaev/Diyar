import 'package:diyar/common/common.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Переключатель «На смене»: только отправка onShift на бэкенд, без перехода на другой экран.
class EndShiftSection extends StatelessWidget {
  const EndShiftSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurierCubit, CurierState>(
      buildWhen: (p, c) => p.isOnShift != c.isOnShift,
      builder: (context, state) {
        final isOnShift = state.isOnShift;
        return SwitchListTile(
          title: const Text('На смене'),
          subtitle: Text(isOnShift ? 'Смена активна' : 'Смена завершена'),
          value: isOnShift,
          onChanged: (value) => _onToggle(context, value),
        );
      },
    );
  }

  Future<void> _onToggle(BuildContext context, bool onShift) async {
    final success = await context.read<CurierCubit>().setOnShift(onShift);
    if (!context.mounted) return;
    if (success) {
      SnackBarMessage().showSuccessSnackBar(
        message: onShift ? 'Вы на смене' : 'Смена завершена',
        context: context,
      );
    } else {
      SnackBarMessage().showErrorSnackBar(
        message: 'Не удалось изменить статус смены',
        context: context,
      );
    }
  }
}
