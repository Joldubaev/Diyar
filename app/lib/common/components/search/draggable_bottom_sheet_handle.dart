import 'package:diyar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Ручка для перетаскивания bottom sheet
class DraggableBottomSheetHandle extends StatelessWidget {
  final Color? color;

  const DraggableBottomSheetHandle({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: color ?? AppColors.grey3,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
