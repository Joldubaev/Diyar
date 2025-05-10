import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

class MenuToggleButton extends StatelessWidget {
  final Function(int idx)? onTapItem;
  final List<CategoryEntity>? categoriesFromPage;

  const MenuToggleButton({
    super.key,
    this.onTapItem,
    this.categoriesFromPage,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showMenu(context),
      icon: const Icon(Icons.menu),
    );
  }

  void showMenu(BuildContext context) {
    if (categoriesFromPage == null || categoriesFromPage!.isEmpty) {
      return;
    }

    final menu = categoriesFromPage!;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 1,
          minChildSize: 0.4,
          expand: false,
          builder: (context, ctrl) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.menu,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      GestureDetector(
                        onTap: () => context.maybePop(),
                        child: const Icon(Icons.close, size: 35),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      controller: ctrl,
                      itemCount: menu.length,
                      itemBuilder: (context, index) {
                        final item = menu[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            onTapItem?.call(index);
                            context.maybePop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  item.name ?? '',
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => Divider(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
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
