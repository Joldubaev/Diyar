import 'dart:io';
import 'package:diyar/core/launch/launch.dart';
import 'package:diyar/features/app/cubit/remote_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppListener extends StatelessWidget {
  const AppListener({
    required this.child,
    required this.navigationKey,
    super.key,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigationKey;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoteConfigCubit, RemoteConfigState>(
      listenWhen: (p, c) => p.appVersionStatus != c.appVersionStatus,
      listener: (context, state) {
        if (state.appVersionStatus is YesRecommendedVersion) {
          _showUpdateDialog(context);
        } else if (state.appVersionStatus is YesRequiredVersion) {
          _showUpdateDialog(context, forceUpdate: true);
        }
      },
      child: child,
    );
  }

  void _showUpdateDialog(BuildContext context, {bool forceUpdate = false}) {
    final ctx = navigationKey.currentState!.overlay!.context;
    showAdaptiveDialog<void>(
      context: ctx,
      barrierDismissible: !forceUpdate,
      builder: (ctx) {
        return PopScope(
          canPop: !forceUpdate,
          child: AlertDialog.adaptive(
            title: Text(
              "Доступно обновление",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: Text(
              // forceUpdate ? ctx.l10n.requiredVersionDescription : ctx.l10n.recommendedVersionDescription,
              forceUpdate
                  ? 'Доступна новая версия приложения. Вам необходимо обновить его, чтобы продолжить использование.'
                  : 'Доступна новая версия приложения.',
            ),
            actions: [
              if (!forceUpdate)
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Напомнить позже',
                    textAlign: TextAlign.center,
                  ),
                ),
              TextButton(
                onPressed: () => AppLaunch.launchURL(_getPlatformAppStoreLink),
                child: const Text(
                  "Обновить сейчас",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String get _getPlatformAppStoreLink {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=kg.cdt.diyar_guest';
    } else {
      return 'https://apps.apple.com/app/id6503710331';
    }
  }
}
