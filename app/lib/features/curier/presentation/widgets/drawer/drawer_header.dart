import 'package:diyar/features/curier/curier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final GetUserEntity user;

  const DrawerHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.primary,
          child: SvgPicture.asset(
            'assets/icons/profile_icon.svg',
            height: 40,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user.userName ?? 'Имя не указано',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          user.phone ?? 'Номер не указан',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
