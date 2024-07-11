import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AboutUsWidget extends StatelessWidget {
  const AboutUsWidget({super.key, required this.image, this.onTap});

  final String image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.aboutUs,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  context.l10n.allAbout,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                ),
                Row(
                  children: [
                    Text(
                      context.l10n.banket,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '→',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
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
