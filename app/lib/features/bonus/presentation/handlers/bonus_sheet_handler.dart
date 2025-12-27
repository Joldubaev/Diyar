import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Handler для управления показом bottom sheet с QR кодом
abstract class BonusSheetHandler {
  /// Показывает bottom sheet с QR кодом
  static Future<void> show(BuildContext context) {
    context.read<BonusCubit>().generateQr();

    return AppBottomSheet.showBottomSheet(
      context,
      const BonusQrSheetContent(),
      initialChildSize: 0.75,
    );
  }
}
