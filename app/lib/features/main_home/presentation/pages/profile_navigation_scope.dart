import 'package:flutter/material.dart';

/// Пробрасывает колбэк «перейти в профиль или потребовать авторизацию» в дочерние табы (HomeTabPage).
class ProfileNavigationScope extends InheritedWidget {
  const ProfileNavigationScope({
    super.key,
    required this.navigateToProfileOrRequireAuth,
    required super.child,
  });

  final Future<bool> Function() navigateToProfileOrRequireAuth;

  static ProfileNavigationScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProfileNavigationScope>();
  }

  @override
  bool updateShouldNotify(ProfileNavigationScope oldWidget) {
    return navigateToProfileOrRequireAuth != oldWidget.navigateToProfileOrRequireAuth;
  }
}
