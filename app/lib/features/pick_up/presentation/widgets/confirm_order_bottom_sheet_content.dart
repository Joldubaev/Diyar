import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/pick_up/pick_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmOrderBottomSheetContent extends StatelessWidget {
  const ConfirmOrderBottomSheetContent({
    super.key,
    required this.theme,
    required this.l10n,
    required this.header,
    required this.details,
    required this.isSubmitting,
    required this.onConfirmTap,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final Widget header;
  final Widget details;
  final bool isSubmitting;
  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                header,
                const SizedBox(height: 15),
                details,
                const Divider(),
                const SizedBox(height: 12),
                BlocBuilder<PickUpCubit, PickUpState>(
                  builder: (context, currentState) {
                    final isSubmitting = currentState is CreatePickUpOrderLoading;
                    return SubmitButtonWidget(
                      textStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                      title: l10n.confirm,
                      bgColor: AppColors.green,
                      isLoading: isSubmitting,
                      onTap: onConfirmTap,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
