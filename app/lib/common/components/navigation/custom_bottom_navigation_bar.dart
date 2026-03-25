import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'glass_navabar_shell.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> with TickerProviderStateMixin {
  late AnimationController _animationController;

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  static const _icons = [
    "assets/icons/home_icon.svg",
    "assets/icons/menu_icon.svg",
    "assets/icons/orders_icon.svg",
    "assets/icons/profile_icon.svg",
  ];

  static const _labels = ["Главная", "Меню", "История", "Профиль"];

  @override
  void initState() {
    super.initState();
    _selectedIndex.value = widget.currentIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _selectedIndex.value = widget.currentIndex;
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;
    // Тёплый серый в тон бренду — гармония с оранжевым
    const unselected = Color(0xFF6B6360);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GlassNavbarShell(
        primary: primary,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / _icons.length;

            return SizedBox(
              height: 72,
              child: Stack(
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _selectedIndex,
                    builder: (context, index, _) {
                      return _NavIndicator(
                        itemWidth: itemWidth,
                        currentIndex: index,
                        primary: primary,
                      );
                    },
                  ),
                  Row(
                    children: List.generate(_icons.length, (index) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (index != widget.currentIndex) {
                              widget.onTap(index);
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: RepaintBoundary(
                            child: _NavItem(
                              index: index,
                              selectedIndex: _selectedIndex.value,
                              primary: primary,
                              unselected: unselected,
                              icon: _icons[index],
                              label: _labels[index],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavIndicator extends StatelessWidget {
  final double itemWidth;
  final int currentIndex;
  final Color primary;

  const _NavIndicator({
    required this.itemWidth,
    required this.currentIndex,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    const horizontalMargin = 6.0;
    final indicatorWidth = itemWidth - horizontalMargin * 2;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 8),
      transform: Matrix4.translationValues(
        currentIndex * itemWidth,
        0,
        0,
      ),
      width: indicatorWidth,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final Color primary;
  final Color unselected;
  final String icon;
  final String label;

  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.primary,
    required this.unselected,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? primary : unselected;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          icon,
          height: 27,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontFamily: 'Inter',
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
