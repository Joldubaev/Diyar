import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';

class AboutUsWidget extends StatelessWidget {
  const AboutUsWidget({super.key, required this.image, this.onTap});

  final String image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.aboutUs,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.black1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  context.l10n.allAbout,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.black1,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      context.l10n.banket,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.black1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '→',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
