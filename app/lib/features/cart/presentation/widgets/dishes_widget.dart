import 'package:diyar/core/core.dart';
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
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

  void _increment() {
    setState(() {
      _count++;
      widget.onChanged?.call(_count);
    });
  }

  void _decrement() {
    if (_count > 0) {
      setState(() {
        _count--;
        widget.onChanged?.call(_count);
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
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/menu_icon.svg', height: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                context.l10n.cutlery,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StepButton(
                    icon: Icons.remove,
                    enabled: _count > 0,
                    onTap: _decrement,
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 22),
                    alignment: Alignment.center,
                    child: Text(
                      '$_count',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _StepButton(
                    icon: Icons.add,
                    enabled: true,
                    onTap: _increment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Компактная круглая кнопка +/- для счётчика приборов.
class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = enabled ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.3);
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
