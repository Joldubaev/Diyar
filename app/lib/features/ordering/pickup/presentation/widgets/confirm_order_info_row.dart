import 'package:diyar/features/ordering/delivery/presentation/widgets/info_dialog_widget.dart';
import 'package:flutter/material.dart';

class ConfirmOrderInfoRow extends StatelessWidget {
  const ConfirmOrderInfoRow({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InfoDialogWidget(
      title: title,
      description: description,
    );
  }
}
