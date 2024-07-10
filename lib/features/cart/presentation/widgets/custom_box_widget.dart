import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomBoxWidget extends StatelessWidget {
  const CustomBoxWidget(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  final IconData icon;
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColors.primary[50],
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, size: 50.0, color: AppColors.grey),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
