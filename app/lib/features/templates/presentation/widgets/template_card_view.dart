import 'package:diyar/features/templates/template.dart';
import 'package:flutter/material.dart';

class TemplateCardView extends StatelessWidget {
  final TemplateEntity template;
  final VoidCallback onTap;
  final VoidCallback? onApply;

  const TemplateCardView({
    super.key,
    required this.template,
    required this.onTap,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              template.templateName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              template.addressData.address,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onApply != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onApply,
                child: const Text('Применить шаблон'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
