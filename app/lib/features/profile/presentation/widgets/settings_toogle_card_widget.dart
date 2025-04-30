import 'package:diyar/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsToggleCard extends StatelessWidget {
  const SettingsToggleCard({
    super.key,
    this.title,
    required this.value,
    this.subtitle,
    this.onChanged,
  });

  final String? title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey,
                fontSize: 14,
              ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset('assets/icons/sec.svg', height: 40),
              const SizedBox(width: 16),
              Text(
                subtitle ?? '',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              if (defaultTargetPlatform == TargetPlatform.android)
                Switch(
                  inactiveThumbColor: AppColors.grey,
                  inactiveTrackColor: AppColors.grey.withValues(alpha: 0.5),
                  activeColor: AppColors.primary,
                  value: value,
                  onChanged: onChanged,
                )
              else
                CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
