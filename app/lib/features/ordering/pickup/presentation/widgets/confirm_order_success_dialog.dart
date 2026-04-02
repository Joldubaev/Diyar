import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class ConfirmOrderSuccessDialog extends StatelessWidget {
  const ConfirmOrderSuccessDialog({
    super.key,
    required this.theme,
    required this.l10n,
    required this.onConfirm,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(
          l10n.yourOrdersConfirm,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          l10n.operatorContact,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 2,
        ),
        actions: [
          SubmitButtonWidget(
            textStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
            title: l10n.ok,
            bgColor: AppColors.green,
            onTap: onConfirm,
          ),
        ],
      ),
    );
  }
}
