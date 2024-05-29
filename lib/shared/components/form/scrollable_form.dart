import 'package:flutter/material.dart';

class ScrollableForm extends StatelessWidget {
  const ScrollableForm({
    required this.listViewChildren,
    required this.columnChildren,
    super.key,
    this.formKey,
    this.listViewKey,
  });

  final GlobalKey<FormState>? formKey;
  final List<Widget> listViewChildren;
  final List<Widget> columnChildren;
  final Key? listViewKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: ListView(
              key: listViewKey,
              children: listViewChildren,
            ),
          ),
          Expanded(
            child: ListView(
              children: columnChildren,
            ),
          ),
        ],
      ),
    );
  }
}
