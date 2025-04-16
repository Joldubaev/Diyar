import '../../theme/theme.dart';
import 'package:flutter/material.dart';

class SubmitButtonWidget extends StatelessWidget {
  const SubmitButtonWidget({
    super.key,
    this.onTap,
    required this.title,
    required this.bgColor,
     this.textStyle,
    this.isLoading = false,
    this.height,
    this.width,
    this.borderColor,
  });

  final VoidCallback? onTap;
  final String title;
  final Color bgColor;
  final TextStyle? textStyle;
  final bool? isLoading;
  final double? height;
  final double? width;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading == true ? null : onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: borderColor != null
            ? borderColor!.withAlpha(1)
            : AppColors.primaryAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height ?? 55),
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
        shadowColor:
            borderColor != null ? AppColors.transparent : AppColors.grey1,
        minimumSize: width != null
            ? Size(width!, height ?? 50)
            : Size.fromHeight(height ?? 50),
        backgroundColor: bgColor,
      ),
      child: isLoading == true
          ? const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(color: AppColors.white),
            )
          : FittedBox(
              child: Text(
                title,
                style: textStyle,
              ),
            ),
    );
  }
}
