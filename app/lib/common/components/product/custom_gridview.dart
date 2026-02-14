import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PaginatedMasonryGridView<T> extends StatelessWidget {
  final List<T> items;
  final bool isLoadingMore;
  final VoidCallback loadMore;
  final Widget Function(BuildContext, T) itemBuilder;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets? padding;

  const PaginatedMasonryGridView({
    required this.items,
    required this.isLoadingMore,
    required this.loadMore,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 10,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100 && !isLoadingMore) {
          loadMore();
        }
        return false;
      },
      child: MasonryGridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        padding: padding,
        itemCount: items.length + (isLoadingMore ? 1 : 0),
        controller: PrimaryScrollController.of(context),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return isLoadingMore
                ? SizedBox(height: 140, child: const CircularProgressIndicator())
                : const SizedBox.shrink();
          }
          return itemBuilder(context, items[index]);
        },
      ),
    );
  }
}
