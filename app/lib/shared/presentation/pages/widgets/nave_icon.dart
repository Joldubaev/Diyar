import 'package:diyar/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavIcon extends StatelessWidget {
  final String iconPath;
  final bool isActive;
  final VoidCallback onTap;

  const NavIcon({
    super.key,
    required this.iconPath,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 46,
        height: 46,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          child: ColoredBox(
            color: isActive
                ? AppColors.primary
                : theme.onSurface.withValues(alpha: 0.1),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  isActive ? AppColors.white : theme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
