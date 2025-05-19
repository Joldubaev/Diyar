import 'package:flutter/material.dart';

class FloatingActionButtonsWidget extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onNavigationPressed;
  final VoidCallback onZoomInPressed;
  final VoidCallback onZoomOutPressed;
  // final VoidCallback onSearchPressed;

  const FloatingActionButtonsWidget({
    super.key,
    required this.theme,
    required this.onNavigationPressed,
    required this.onZoomInPressed,
    required this.onZoomOutPressed,
    // required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            mini: true,
            onPressed: onZoomInPressed,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'zoom_out',
            mini: true,
            onPressed: onZoomOutPressed,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'navigation',
            onPressed: onNavigationPressed,
            child: const Icon(Icons.navigation),
          ),
          const SizedBox(height: 230),
        ],
      ),
    );
  }
}
