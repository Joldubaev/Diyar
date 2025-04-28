import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DishesWidget extends StatefulWidget {
  final ValueChanged<int>? onChanged;
  final int initialCount;

  const DishesWidget({
    super.key,
    this.onChanged,
    this.initialCount = 0,
  });

  @override
  State<DishesWidget> createState() => _DishesWidgetState();
}

class _DishesWidgetState extends State<DishesWidget> {
  late int _cutleryCount;

  @override
  void initState() {
    super.initState();
    _cutleryCount = widget.initialCount;
  }

  void _incrementCutlery() {
    setState(() {
      _cutleryCount++;
      widget.onChanged?.call(_cutleryCount);
    });
  }

  void _decrementCutlery() {
    if (_cutleryCount > 0) {
      setState(() {
        _cutleryCount--;
        widget.onChanged?.call(_cutleryCount);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset('assets/icons/menu_icon.svg', height: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                context.l10n.cutlery,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    visualDensity: VisualDensity.compact,
                    splashRadius: 20,
                    iconSize: 20,
                    color: _cutleryCount > 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    onPressed: _cutleryCount > 0 ? _decrementCutlery : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      _cutleryCount.toString(),
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    splashRadius: 20,
                    iconSize: 20,
                    icon: const Icon(Icons.add),
                    color: theme.colorScheme.primary,
                    onPressed: _incrementCutlery,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
