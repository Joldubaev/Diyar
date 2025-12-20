import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:flutter/material.dart';

/// Кнопки для применения шаблона или перехода на карту
class TemplateBottomButtons extends StatelessWidget {
  final String? selectedTemplateId;
  final CartLoaded cartState;
  final TemplateEntity? selectedTemplate;
  final VoidCallback onApplyTemplate;
  final VoidCallback onSkip;

  const TemplateBottomButtons({
    super.key,
    required this.selectedTemplateId,
    required this.cartState,
    required this.selectedTemplate,
    required this.onApplyTemplate,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SubmitButtonWidget(
            title: 'Применить',
            bgColor: theme.colorScheme.primary,
            onTap: selectedTemplateId != null ? onApplyTemplate : null,
          ),
          const SizedBox(height: 12),
          CustomTextButton(
            textButton: 'Пропустить',
            onPressed: onSkip,
          ),
        ],
      ),
    );
  }
}
