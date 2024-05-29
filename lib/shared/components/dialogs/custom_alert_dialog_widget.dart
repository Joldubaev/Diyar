import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  final Widget content;
  final VoidCallback onOk;
  final VoidCallback onCancel;
  final Widget onCancelText;
  final Widget onOkText;
  final Widget? title;

  const CustomAlertDialogWidget({
    super.key,
    required this.content,
    required this.onOk,
    required this.onCancel,
    required this.onCancelText,
    required this.onOkText,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            content: content,
            actions: [
              CupertinoDialogAction(
                onPressed: onCancel,
                child: onCancelText,
              ),
              CupertinoDialogAction(
                onPressed: onOk,
                child: onCancelText,
              ),
            ],
          )
        : AlertDialog(
            title: title,
            content: content,
            actions: [
              TextButton(
                onPressed: onCancel,
                child: onCancelText,
              ),
              TextButton(
                onPressed: onOk,
                child: onOkText,
              ),
            ],
          );
  }
}
