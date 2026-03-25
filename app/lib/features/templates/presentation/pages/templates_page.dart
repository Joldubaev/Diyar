import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/templates/presentation/cubit/templates_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'templates_page_content.dart';

@RoutePage()
class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<TemplatesListCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Мои шаблоны')),
        body: const TemplatesPageContent(),
      ),
    );
  }
}
