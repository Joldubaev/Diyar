import 'package:diyar/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    super.key,
    this.onPressed,
    this.color,
  });
  final Function? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            onPressed!();
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(top: 0, bottom: 20, left: 10, right: 10),
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blue),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset('assets/icons/google.svg'),
            ),
          ),
        ),
      ],
    );
  }
}
