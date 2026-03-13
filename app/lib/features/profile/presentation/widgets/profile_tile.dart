import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    required this.imgPath,
    required this.text,
    this.isSvg = false,
    super.key,
  });

  final String imgPath;
  final String text;
  final bool? isSvg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.orange,
              child: isSvg!
                  ? SvgPicture.asset(
                      imgPath,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                      width: 32,
                    )
                  : Image.asset(imgPath),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: context.textTheme.bodyLarge)),
          const SizedBox(width: 10),
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
