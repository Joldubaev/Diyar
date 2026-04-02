import 'package:flutter/cupertino.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required this.confirmText,
    required this.confirmIsDestructive,
    required this.confirmPressed,
    required this.confirmIsDefault,
    required this.onFinish,
  });

  final String? confirmText;
  final bool confirmIsDestructive;
  final VoidCallback? confirmPressed;
  final bool confirmIsDefault;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    return CupertinoDialogAction(
      isDefaultAction: confirmIsDefault,
      isDestructiveAction: confirmIsDestructive,
      onPressed: () {
        confirmPressed?.call();
        onFinish?.call();
      },
      child: Text(confirmText ?? 'Да'),
    );
  }
}
