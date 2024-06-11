import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.title,
    required this.trailing,
  });
  final String title;
  final String trailing;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.grey,
              )),
          Text(
            trailing,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: AppColors.black1,
            ),
          ),
        ],
      ),
    );
  }
}
