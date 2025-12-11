import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/presentation/cubit/templates_cubit.dart';
import 'package:diyar/features/templates/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TemplatesCubit>();
    return BlocProvider.value(
      value: cubit..fetchTemplates(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мои шаблоны'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.router.push(CreateTemplateRoute());
              },
            ),
          ],
        ),
        body: BlocConsumer<TemplatesCubit, TemplatesState>(
          listener: (context, state) {
            final snackBar = SnackBarMessage();
            if (state is TemplatesError) {
              snackBar.showErrorSnackBar(
                message: state.message,
                context: context,
              );
            } else if (state is TemplatesDeleteSuccess) {
              snackBar.showSuccessSnackBar(
                message: 'Шаблон успешно удален',
                context: context,
              );
            } else if (state is TemplatesUpdateSuccess) {
              snackBar.showSuccessSnackBar(
                message: 'Шаблон успешно обновлен',
                context: context,
              );
            }
          },
          builder: (context, state) {
            if (state is TemplatesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TemplatesLoaded) {
              if (state.templates.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/cart.svg', width: 200, height: 200),
                      const SizedBox(height: 16),
                      Text(
                        'Нет шаблонов',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Создайте свой первый шаблон',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.templates.length,
                itemBuilder: (context, index) {
                  final template = state.templates[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Dismissible(
                      key: Key(template.id ?? 'template_$index'),
                      direction: DismissDirection.endToStart,
                      background: Container(
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
                      ),
                      confirmDismiss: (direction) async {
                        if (template.id != null) {
                          return await DeleteConfirmationDialog.show(
                            context: context,
                            title: 'Удалить шаблон',
                            message: 'Вы уверены, что хотите удалить этот шаблон?',
                          );
                        }
                        return false;
                      },
                      onDismissed: (direction) {
                        if (template.id != null) {
                          context.read<TemplatesCubit>().deleteTemplate(template.id!);
                        }
                      },
                      child: TemplateCard(
                        template: template,
                        onTap: () {
                          context.router.push(
                            CreateTemplateRoute(template: template),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }

            if (state is TemplatesError) {
              return EmptyTemplateWidget();
            }

            return const Center(child: Text('Initial state'));
          },
        ),
      ),
    );
  }
}
