import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueNotifier<int> activeIndex;
  final Function(int) onCategoryTap;
  final ScrollController scrollController;

  const CategoryList({
    super.key,
    required this.categories,
    required this.activeIndex,
    required this.onCategoryTap,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 35,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => ValueListenableBuilder<int>(
          valueListenable: activeIndex,
          builder: (context, activeIdx, _) {
            final item = categories[index];
            final name = item.name?.trim().isNotEmpty == true ? item.name! : 'Без названия';
            return GestureDetector(
              onTap: () => onCategoryTap(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: index == activeIdx ? theme.colorScheme.primary : theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: index == activeIdx ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    width: 0.4,
                  ),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: index == activeIdx
                          ? theme.colorScheme.surface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
