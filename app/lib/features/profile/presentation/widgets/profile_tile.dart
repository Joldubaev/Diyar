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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            child: isSvg!
                ? SvgPicture.asset(
                    imgPath,
                    colorFilter: ColorFilter.mode(
                      scheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    width: 70,
                  )
                : Image.asset(imgPath),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: textTheme.bodyLarge)),
          const SizedBox(width: 10),
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
