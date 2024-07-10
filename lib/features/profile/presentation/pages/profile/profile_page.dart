import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/profile/presentation/presentation.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel user;
  String version = '';

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUser();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = '${info.version} (${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.l10n.cabinet,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.white,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileGetError) {
            context.read<SignInCubit>().logout().then((value) {
              context.router.pushAndPopUntil(
                const MainRoute(),
                predicate: (_) => false,
              );
            });
          }
        },
        builder: (context, state) {
          if (state is ProfileGetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileGetError) {
            return Center(child: Text(context.l10n.loadedWrongData));
          } else if (state is ProfileGetLoaded) {
            user = state.userModel;
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.pushRoute(ProfileInfoRoute(user: user)),
                  child: ProfileTile(
                    imgPath: 'assets/icons/profile_icon.svg',
                    text: '${user.name}',
                    isSvg: true,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SettingsTile(
                        text: context.l10n.aboutUs,
                        onPressed: () =>
                            context.pushRoute(const AboutUsRoute()),
                      ),
                      SettingsTile(
                        text: context.l10n.contact,
                        onPressed: () =>
                            context.pushRoute(const ContactRoute()),
                      ),
                      SettingsTile(
                        text: context.l10n.policy,
                        onPressed: () => AppLaunch.launchURL(AppConst.terms),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SettingsTile(
                    text: context.l10n.exit,
                    onPressed: () {
                      AppAlert.showConfirmDialog(
                        context: context,
                        title: context.l10n.exit,
                        content: Text(context.l10n.areYouSure),
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
                    icon: Icons.exit_to_app,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: VersionWidgets(
                    leading: const Icon(Icons.local_fire_department),
                    title: context.l10n.appVersion,
                    trailing: Text(version, style: theme.textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
