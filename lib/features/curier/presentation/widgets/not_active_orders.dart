import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyActiveOrders extends StatelessWidget {
  const EmptyActiveOrders({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/active.svg',
                width: 200, height: 200),
            const SizedBox(height: 20),
            FittedBox(
              child: Text(
                text,
                style:
                    theme.textTheme.bodyLarge!.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
