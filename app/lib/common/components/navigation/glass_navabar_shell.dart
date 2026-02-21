
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassNavbarShell extends StatelessWidget {
  final Widget child;
  final Color primary;

  const GlassNavbarShell({super.key, required this.child, required this.primary});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FakeGlass(
        shape: const LiquidRoundedSuperellipse(borderRadius: 30),
        settings: const LiquidGlassSettings(
          blur: 18,
          thickness: 12,
          glassColor: Color(0x26FFFFFF),
          lightIntensity: 0.65,
          ambientStrength: 0.12,
          saturation: 1.3,
        ),
        child: child,
      ),
    );
  }
}
