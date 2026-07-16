import 'package:diyar/common/common.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Handler для управления показом bottom sheet с QR кодом
abstract class BonusSheetHandler {
  /// Показывает bottom sheet с QR кодом
  /// (при выключенном [BonusFlags.qrEnabled] — заглушку без запроса к API).
  static Future<void> show(BuildContext context) {
    if (!BonusFlags.qrEnabled) {
      return AppBottomSheet.showBottomSheet(
        context,
        const BonusQrSheetContent(),
        initialChildSize: 0.55,
      );
    }

    final cubit = context.read<BonusCubit>()..generateQr();

    return AppBottomSheet.showBottomSheet(
      context,
      BlocProvider.value(
        value: cubit,
        child: const BonusQrSheetContent(),
      ),
      initialChildSize: 0.75,
    );
  }
}
