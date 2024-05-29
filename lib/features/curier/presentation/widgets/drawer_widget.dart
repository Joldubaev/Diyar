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

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  GetUserModel user = GetUserModel();

  @override
  void initState() {
    super.initState();
    context.read<CurierCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurierCubit, CurierState>(
      listener: (context, state) {
        if (state is GetUserError) {
          context.read<SignInCubit>().logout().then((value) {
            context.router.pushAndPopUntil(
              const MainRoute(),
              predicate: (_) => false,
            );
          });
        }
      },
      builder: (context, state) {
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
                            height: 80, colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn))),
                    const SizedBox(height: 10),
                    Text("${state is GetUserLoaded ? state.user.userName : ""}",
                        style: const TextStyle(color: AppColors.black1, fontSize: 18)),
                    Text("${state is GetUserLoaded ? state.user.phone : ""}",
                        style: const TextStyle(color: AppColors.black1)),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(context.l10n.profile, style: theme.textTheme.bodyMedium!.copyWith(color: AppColors.black1)),
                onTap: () {
                  context.maybePop();
                  context.router.push(const CurierRoute());
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text(context.l10n.activeOrders,
                    style: theme.textTheme.bodyMedium!.copyWith(color: AppColors.black1)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(context.l10n.orderHistory,
                    style: theme.textTheme.bodyMedium!.copyWith(color: AppColors.black1)),
                onTap: () {
                  context.maybePop();
                  context.router.push(const HistoryRoute());
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.l10n.exit, style: theme.textTheme.bodyMedium!.copyWith(color: AppColors.red)),
                onTap: () {
                  AppAlert.showConfirmDialog(
                    context: context,
                    title: context.l10n.exit,
                    content: Text(context.l10n.areYouSure, style: theme.textTheme.bodyMedium),
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
      },
    );
  }
}
