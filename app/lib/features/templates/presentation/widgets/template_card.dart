import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:flutter/material.dart';

class TemplateCard extends StatelessWidget {
  final TemplateEntity template;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;

  const TemplateCard({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onSelectedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.outline.withValues(alpha: 0.12),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_outline,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.templateName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _buildAddress(template),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            /// ACTIONS
            GestureDetector(
              onTap: () => onSelectedChanged(!isSelected),
              behavior: HitTestBehavior.opaque,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) => onSelectedChanged(value ?? false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildAddress(TemplateEntity template) {
    final address = template.addressData.address;
    final house = template.addressData.houseNumber;
    return house.isNotEmpty ? '$address, д. $house' : address;
  }
}
