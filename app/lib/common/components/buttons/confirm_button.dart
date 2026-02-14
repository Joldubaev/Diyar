import 'package:flutter/cupertino.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required this.confirmText,
    required this.confirmIsDestructive,
    required this.confirmPressed,
    required this.confirmlIsDefault,
    required this.onFinish,
  });

  final String? confirmText;
  final bool confirmIsDestructive;
  final void Function()? confirmPressed;
  final bool confirmlIsDefault;
  final void Function()? onFinish;

  @override
  Widget build(BuildContext context) {
    return CupertinoDialogAction(
      isDefaultAction: confirmlIsDefault,
      isDestructiveAction: confirmIsDestructive,
      onPressed: () {
        confirmPressed?.call();
        onFinish?.call();
      },
      child: Text(confirmText ?? 'Да'),
    );
  }
}
