import 'package:flutter/material.dart';

@immutable
class AppBottomSheet {
  static Future<void> showBottomSheet(
    BuildContext context,
    Widget child, {
    double initialChildSize = 0.6,
    double maxChildSize = 0.9,
    double minChildSize = 0.4,
    ScrollPhysics? physics = const BouncingScrollPhysics(),
    Key? scrollKey,
  }) async {
    Scaffold.of(context).showBottomSheet(
      (context) => BottomSheet(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        onClosing: () {},
        builder: (context) => child,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
    );
  }

  static Future<T?> showDraggableScrollableSheet<T>(
    BuildContext context,
    Widget child, {
    double initialChildSize = 0.6,
    double maxChildSize = 0.9,
    double minChildSize = 0.4,
    ScrollPhysics? physics = const BouncingScrollPhysics(),
    Key? scrollKey,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          maxChildSize: maxChildSize,
          minChildSize: minChildSize,
          expand: false,
          builder: (c, s) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const SizedBox(
                    height: 30,
                    child: Icon(Icons.maximize_rounded, size: 50),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      key: scrollKey,
                      physics: physics,
                      controller: s,
                      child: child,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
