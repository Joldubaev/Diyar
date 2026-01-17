import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'templates_page_content.dart';

@RoutePage()
class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои шаблоны')),
      body: const TemplatesPageContent(),
    );
  }
}
