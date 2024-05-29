import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class MenuCategoryNameListWidget extends StatelessWidget {
  const MenuCategoryNameListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              "${context.l10n.category} $index",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: 9,
      ),
    );
  }
}
