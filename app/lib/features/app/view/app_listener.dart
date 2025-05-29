import 'dart:io';
import 'package:diyar/core/launch/launch.dart';
import 'package:diyar/features/app/cubit/remote_config_cubit.dart';
import 'package:diyar/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppListener extends StatefulWidget {
  const AppListener({
    required this.child,
    required this.navigationKey,
    super.key,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigationKey;

  @override
  State<AppListener> createState() => _AppListenerState();
}

class _AppListenerState extends State<AppListener> {
  bool _isTechnicalWorkDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SettingsCubit>().getTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RemoteConfigCubit, RemoteConfigState>(
          listenWhen: (p, c) => p.appVersionStatus != c.appVersionStatus,
          listener: (context, state) {
            if (_isTechnicalWorkDialogShowing) return;
            if (state.appVersionStatus is YesRecommendedVersion) {
              _showUpdateDialog(context);
            } else if (state.appVersionStatus is YesRequiredVersion) {
              _showUpdateDialog(context, forceUpdate: true);
            }
          },
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (p, c) => c is TimerLoaded,
          listener: (context, state) {
            if (state is TimerLoaded) {
              final loadedTimer = state.timer;
              if (loadedTimer.isTechnicalWork != null) {
                final bool isTechnicalWorkActive = loadedTimer.isTechnicalWork ?? false;
                if (isTechnicalWorkActive && !_isTechnicalWorkDialogShowing) {
                  _showTechnicalWorkDialog(context);
                } else if (!isTechnicalWorkActive && _isTechnicalWorkDialogShowing) {
                  if (Navigator.canPop(widget.navigationKey.currentState!.overlay!.context)) {
                    Navigator.pop(widget.navigationKey.currentState!.overlay!.context);
                  }
                }
              }
            }
          },
        ),
      ],
      child: widget.child,
    );
  }

  void _showUpdateDialog(BuildContext context, {bool forceUpdate = false}) {
    final ctx = widget.navigationKey.currentState!.overlay!.context;
    showAdaptiveDialog<void>(
      context: ctx,
      barrierDismissible: !forceUpdate,
      builder: (ctx) {
        return PopScope(
          canPop: !forceUpdate,
          child: AlertDialog.adaptive(
            title: Text(
              "Доступно обновление",
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
            content: Text(
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

  void _showTechnicalWorkDialog(BuildContext context) {
    setState(() {
      _isTechnicalWorkDialogShowing = true;
    });
    final ctx = widget.navigationKey.currentState!.overlay!.context;
    showAdaptiveDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog.adaptive(
            title: Text(
              'Технические работы',
              style: Theme.of(dialogContext).textTheme.titleMedium,
            ),
            content: Text(
              'В данный момент на сервере проводятся технические работы. Приложение временно недоступно. Пожалуйста, попробуйте позже.',
              style: Theme.of(dialogContext).textTheme.bodyMedium,
            ),
          ),
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() {
          _isTechnicalWorkDialogShowing = false;
        });
      }
    });
  }

  String get _getPlatformAppStoreLink {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=kg.cdt.diyar_guest';
    } else {
      return 'https://apps.apple.com/app/id6503710331';
    }
  }
}
