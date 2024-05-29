import 'package:diyar/shared/theme/theme.dart';
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            child: isSvg!
                ? SvgPicture.asset(
                    imgPath,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    width: 70,
                  )
                : Image.asset(imgPath),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
          const SizedBox(width: 10),
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
