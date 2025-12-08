import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/templates/presentation/cubit/templates_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<TemplatesCubit>()..fetchTemplates(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Templates'),
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
            if (state is TemplatesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is TemplatesDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Template deleted successfully')),
              );
            } else if (state is TemplatesUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Template updated successfully')),
              );
            }
          },
          builder: (context, state) {
            if (state is TemplatesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TemplatesLoaded) {
              if (state.templates.isEmpty) {
                return const Center(
                  child: Text('No templates found'),
                );
              }

              return ListView.builder(
                itemCount: state.templates.length,
                itemBuilder: (context, index) {
                  final template = state.templates[index];
                  return ListTile(
                    title: Text(template.templateName),
                    subtitle: Text(template.addressData.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            context.router.push(
                              CreateTemplateRoute(template: template),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (template.id != null) {
                              _showDeleteDialog(context, template.id!);
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      if (template.id != null) {
                        context.read<TemplatesCubit>().fetchTemplateById(template.id!);
                      }
                    },
                  );
                },
              );
            }

            if (state is TemplatesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TemplatesCubit>().fetchTemplates();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Initial state'));
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String templateId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Template'),
        content: const Text('Are you sure you want to delete this template?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TemplatesCubit>().deleteTemplate(templateId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
