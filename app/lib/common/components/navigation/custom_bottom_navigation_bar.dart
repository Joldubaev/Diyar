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
  late List<AnimationController> _colorControllers;

  double _dragPosition = 0;
  bool _isDragging = false;

  static const _icons = [
    "assets/icons/home_icon.svg",
    "assets/icons/menu_icon.svg",
    "assets/icons/orders_icon.svg",
    "assets/icons/profile_icon.svg",
  ];

  static const _labels = ["Главная", "Меню", "История", "Профиль"];
  static const _unselected = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _colorControllers = List.generate(
      _icons.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 280),
        value: i == widget.currentIndex ? 1.0 : 0.0,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _colorControllers[oldWidget.currentIndex].reverse();
      _colorControllers[widget.currentIndex].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _colorControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: GlassNavbarShell(
        primary: primary,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / _icons.length;

            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _isDragging = true;
                  _dragPosition = (_dragPosition + details.delta.dx).clamp(0, constraints.maxWidth - itemWidth);
                });
                final idx = (_dragPosition / itemWidth).round();
                if (idx != widget.currentIndex) widget.onTap(idx);
              },
              onHorizontalDragEnd: (_) => setState(() => _isDragging = false),
              child: SizedBox(
                height: 72,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeInOutCubic,
                      left: _isDragging ? _dragPosition : (widget.currentIndex * itemWidth),
                      top: 8,
                      bottom: 8,
                      child: Container(
                        width: itemWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(_icons.length, (index) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => widget.onTap(index),
                            behavior: HitTestBehavior.opaque,
                            child: AnimatedBuilder(
                              animation: _colorControllers[index],
                              builder: (context, _) {
                                final t = _colorControllers[index].value;
                                final color = Color.lerp(_unselected, primary, t)!;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 1.0 + 0.12 * t,
                                      child: SvgPicture.asset(
                                        _icons[index],
                                        height: 27,
                                        colorFilter: ColorFilter.mode(
                                          color,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _labels[index],
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 11,
                                        fontWeight: FontWeight.lerp(
                                          FontWeight.w500,
                                          FontWeight.w700,
                                          t,
                                        ),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
