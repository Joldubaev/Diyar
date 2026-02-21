import 'package:diyar/core/core.dart';
import 'package:diyar/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? savedAddress;
  final VoidCallback onAddressTap;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    super.key,
    required this.savedAddress,
    required this.onAddressTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16,
      title: GestureDetector(
        onTap: onAddressTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.grey2,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: primary, size: 20),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  savedAddress ?? 'Укажите адрес доставки',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down_rounded, color: primary, size: 22),
            ],
          ),
        ),
      ),
      actions: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final userName = context.read<ProfileCubit>().user?.userName;
            if (userName == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
