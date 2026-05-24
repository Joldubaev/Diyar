import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Общая обёртка Shimmer для всего файла.
class _ShimmerWrap extends StatelessWidget {
  const _ShimmerWrap({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: child,
    );
  }
}

// Прямоугольный блок-заглушка.
class _Box extends StatelessWidget {
  const _Box({
    required this.width,
    required this.height,
    this.radius = 8,
  });
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

// Круглая заглушка.
class _Circle extends StatelessWidget {
  const _Circle(this.size);
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );
}

/// Скелетон строки заголовка (аватар + текст + иконка меню).
class CurierHeaderShimmer extends StatelessWidget {
  const CurierHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
      child: _ShimmerWrap(
        child: Row(
          children: [
            const _Circle(48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _Box(width: 80, height: 12),
                  SizedBox(height: 6),
                  _Box(width: 130, height: 16),
                ],
              ),
            ),
            const _Box(width: 40, height: 40, radius: 20),
          ],
        ),
      ),
    );
  }
}

/// Скелетон карточки переключения смены.
class ShiftToggleCardShimmer extends StatelessWidget {
  const ShiftToggleCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _ShimmerWrap(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const _Circle(48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _Box(width: 100, height: 16),
                    SizedBox(height: 6),
                    _Box(width: 180, height: 12),
                  ],
                ),
              ),
              const _Box(width: 20, height: 20, radius: 4),
            ],
          ),
        ),
      ),
    );
  }
}

/// Скелетон одной карточки заказа.
class CurierOrderCardShimmer extends StatelessWidget {
  const CurierOrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerWrap(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            const _Circle(40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _Box(width: 120, height: 16),
                  SizedBox(height: 6),
                  _Box(width: 80, height: 12),
                ],
              ),
            ),
            const _Box(width: 24, height: 24, radius: 4),
          ],
        ),
      ),
    );
  }
}

/// Полный скелетон страницы: заголовок + карточка смены + N карточек заказов.
class CurierPageShimmer extends StatelessWidget {
  const CurierPageShimmer({super.key, this.orderCount = 3});

  final int orderCount;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: CurierHeaderShimmer()),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: ShiftToggleCardShimmer(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          sliver: SliverList.separated(
            itemCount: orderCount,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, __) => const CurierOrderCardShimmer(),
          ),
        ),
      ],
    );
  }
}

/// Скелетон карточки истории заказов.
class HistoryCardShimmer extends StatelessWidget {
  const HistoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerWrap(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Box(width: 160, height: 16),
                _Box(width: 72, height: 24, radius: 8),
              ],
            ),
            SizedBox(height: 16),
            _Box(width: double.infinity, height: 1),
            SizedBox(height: 12),
            Row(children: [_Circle(16), SizedBox(width: 6), _Box(width: 110, height: 13)]),
            SizedBox(height: 8),
            Row(children: [_Circle(16), SizedBox(width: 6), _Box(width: 180, height: 13)]),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Box(width: 80, height: 12),
                _Box(width: 90, height: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Скелетон списка истории заказов.
class HistoryListShimmer extends StatelessWidget {
  const HistoryListShimmer({super.key, this.count = 5});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const HistoryCardShimmer(),
    );
  }
}

/// Скелетон только для списка заказов (когда заголовок уже отрисован).
class CurierOrdersShimmer extends StatelessWidget {
  const CurierOrdersShimmer({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      sliver: SliverList.separated(
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, __) => const CurierOrderCardShimmer(),
      ),
    );
  }
}
