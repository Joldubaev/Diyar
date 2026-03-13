import 'dart:ui';

import 'package:flutter/material.dart';

class GlassNavbarShell extends StatelessWidget {
  final Widget child;
  final Color primary;

  const GlassNavbarShell({super.key, required this.child, required this.primary});

  @override
  Widget build(BuildContext context) {
    // Тёплые оттенки в тон бренду + цвета из темы
    final scheme = Theme.of(context).colorScheme;
    final shadow = primary.withValues(alpha: 0.12);

    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: scheme.surface.withValues(alpha: 0.9),
                border: Border.all(
                  color: primary.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: primary.withValues(alpha: 0.03),
                      ),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
