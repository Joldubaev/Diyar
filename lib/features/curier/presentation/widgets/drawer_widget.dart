import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/data/model/get_user_moderl.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetUserModel user = context.read<CurierCubit>().user!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 30,
                    child: SvgPicture.asset('assets/icons/profile_icon.svg',
                        height: 80,
                        colorFilter: const ColorFilter.mode(
                            AppColors.white, BlendMode.srcIn))),
                const SizedBox(height: 10),
                Text(user.userName ?? 'Нет',
                    style:
                        const TextStyle(color: AppColors.black1, fontSize: 18)),
                Text(user.phone ?? 'Нет номер телефона',
                    style: const TextStyle(color: AppColors.black1)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: Text(context.l10n.activeOrders,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: AppColors.black1)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(context.l10n.orderHistory,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: AppColors.black1)),
            onTap: () {
              context.maybePop();
              context.router.push(const HistoryRoute());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(context.l10n.exit,
                style:
                    theme.textTheme.bodyMedium!.copyWith(color: AppColors.red)),
            onTap: () {
              AppAlert.showConfirmDialog(
                context: context,
                title: context.l10n.exit,
                content: Text(context.l10n.areYouSure,
                    style: theme.textTheme.bodyMedium),
                cancelText: context.l10n.no,
                confirmText: context.l10n.yes,
                cancelPressed: () => Navigator.pop(context),
                confirmPressed: () {
                  context.read<SignInCubit>().logout().then((value) {
                    context.router.pushAndPopUntil(
                      const SignInRoute(),
                      predicate: (_) => false,
                    );
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
