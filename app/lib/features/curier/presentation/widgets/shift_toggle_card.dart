import 'package:diyar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ShiftToggleCard extends StatefulWidget {
  const ShiftToggleCard({
    super.key,
    required this.isOnShift,
    required this.isLoading,
    required this.onToggle,
  });

  final bool isOnShift;
  final bool isLoading;
  final VoidCallback onToggle;

  @override
  State<ShiftToggleCard> createState() => _ShiftToggleCardState();
}

class _ShiftToggleCardState extends State<ShiftToggleCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacity = Tween<double>(begin: 0.2, end: 1.0).animate(_pulse);
    if (widget.isOnShift) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ShiftToggleCard old) {
    super.didUpdateWidget(old);
    if (widget.isOnShift == old.isOnShift) return;
    if (widget.isOnShift) {
      _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final iconBg = widget.isOnShift ? primary.withValues(alpha: 0.12) : AppColors.grey1;
    final iconColor = widget.isOnShift ? primary : AppColors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                    child: widget.isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2, color: iconColor),
                          )
                        : Icon(Icons.power_settings_new_rounded, color: iconColor, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.isOnShift ? 'На смене' : 'Начать смену',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.isOnShift ? 'Нажмите чтобы завершить смену' : 'Нажмите чтобы начать смену',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isOnShift) ...[
                    FadeTransition(
                      opacity: _opacity,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Icon(Icons.chevron_right_rounded, color: AppColors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
