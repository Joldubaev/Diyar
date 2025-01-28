import 'package:flutter/material.dart';

class FloatingActionButtonsWidget extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onNavigationPressed;
  final VoidCallback onSearchPressed;

  const FloatingActionButtonsWidget({
    super.key,
    required this.theme,
    required this.onNavigationPressed,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'navigation',
            onPressed: onNavigationPressed,
            child: const Icon(Icons.navigation),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'search',
            backgroundColor: theme.colorScheme.onTertiaryFixed,
            onPressed: onSearchPressed,
            child: Icon(Icons.search, color: theme.colorScheme.onSurface, size: 40),
          ),
          const SizedBox(height: 230),
        ],
      ),
    );
  }
}