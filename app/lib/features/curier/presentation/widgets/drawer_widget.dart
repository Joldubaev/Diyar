import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    GetUserModel user = context.read<CurierCubit>().user ?? GetUserModel();
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.secondary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 30,
                    child: SvgPicture.asset('assets/icons/profile_icon.svg',
                        height: 80,
                        colorFilter: ColorFilter.mode(
                            theme.colorScheme.onSurface, BlendMode.srcIn))),
                const SizedBox(height: 10),
                Text(user.userName ?? context.l10n.no,
                    style: TextStyle(
                        color: theme.colorScheme.onSurface, fontSize: 18)),
                Text(user.phone ?? context.l10n.noPhoneNumber,
                    style: TextStyle(
                        color: theme.colorScheme.onSurface, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: Text(context.l10n.activeOrders,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: theme.colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(context.l10n.orderHistory,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: theme.colorScheme.onSurface)),
            onTap: () {
              context.maybePop();
              context.router.push(const HistoryRoute());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(context.l10n.exit,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: theme.colorScheme.error)),
            onTap: () {
              AppAlert.showConfirmDialog(
                context: context,
                title: context.l10n.exit,
                content: Text(context.l10n.areYouSure,
                    style: Theme.of(context).textTheme.bodyMedium),
                cancelText: context.l10n.no,
                confirmText: context.l10n.yes,
                cancelPressed: () => Navigator.pop(context),
                confirmPressed: () {
                  context.read<SignInCubit>().logout().then((value) {
                    if (context.mounted) {
                      context.router.pushAndPopUntil(
                        const SignInRoute(),
                        predicate: (_) => false,
                      );
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
