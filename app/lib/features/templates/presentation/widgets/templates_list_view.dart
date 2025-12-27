import 'package:diyar/features/templates/presentation/presentation.dart';
import 'package:diyar/features/templates/presentation/widgets/template_list_item.dart';
import 'package:flutter/material.dart';

/// Виджет для отображения списка шаблонов
class TemplatesListView extends StatelessWidget {
  final TemplatesListLoaded state;
  final TemplatesListCubit cubit;

  const TemplatesListView({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final template = state.templates[index];
            return TemplateListItem(
              template: template,
              isSelected: state.selectedTemplateId == template.id,
              onSelectedChanged: (selected) {
                cubit.selectTemplate(
                  selected ? template.id : null,
                );
              },
            );
          },
          childCount: state.templates.length,
        ),
      ),
    );
  }
}

