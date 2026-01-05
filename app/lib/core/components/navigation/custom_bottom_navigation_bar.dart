import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unselectedColor =
        Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.8) : Colors.grey;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: theme.colorScheme.surface,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: unselectedColor,
      items: [
        _buildBottomNavItem(context, "assets/icons/home_icon.svg", "Главная", currentIndex == 0, unselectedColor,
            theme.colorScheme.primary),
        _buildBottomNavItem(context, "assets/icons/menu_icon.svg", "Меню", currentIndex == 1, unselectedColor,
            theme.colorScheme.primary),
        _buildBottomNavItem(context, "assets/icons/orders_icon.svg", "История", currentIndex == 2, unselectedColor,
            theme.colorScheme.primary),
        _buildBottomNavItem(context, "assets/icons/profile_icon.svg", "Профиль", currentIndex == 3, unselectedColor,
            theme.colorScheme.primary),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    BuildContext context,
    String iconPath,
    String label,
    bool isSelected,
    Color unselectedIconColor,
    Color selectedIconColor,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        height: 24,
        colorFilter: ColorFilter.mode(
          isSelected ? selectedIconColor : unselectedIconColor,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
