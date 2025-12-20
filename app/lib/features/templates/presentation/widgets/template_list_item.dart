import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/presentation/widgets/widget.dart';
import 'package:diyar/features/templates/template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemplateListItem extends StatelessWidget {
  final TemplateEntity template;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;

  const TemplateListItem({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onSelectedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey(template.id),
        direction: DismissDirection.endToStart,
        background: _DeleteBackground(),
        confirmDismiss: (_) async {
          if (template.id == null) return false;

          final confirmed = await DeleteConfirmationDialog.show(
            context: context,
            title: 'Удалить шаблон',
            message: 'Вы уверены, что хотите удалить этот шаблон?',
          );

          if (confirmed == true && context.mounted) {
            context.read<TemplatesListCubit>().deleteTemplate(template.id!);
          }

          return false;
        },
        child: TemplateCard(
          template: template,
          isSelected: isSelected,
          onSelectedChanged: onSelectedChanged,
        ),
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
