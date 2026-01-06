import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/presentation/presentation.dart';
import 'package:diyar/features/security/presentation/presentation.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final GetUserEntity user = context.read<CurierCubit>().user!;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(context, user, theme),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.delivery_dining_outlined,
                    title: 'Активные заказы',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.history_toggle_off_outlined,
                    title: 'История заказов',
                    onTap: () {
                      context.maybePop();
                      context.router.push(const HistoryRoute());
                    },
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  _buildBiometricSection(context, theme),
                ],
              ),
            ),
            _buildLogoutSection(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, GetUserEntity user, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          user.phone ?? 'Номер не указан',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? theme.colorScheme.primary,
        size: 26, // Немного увеличим размер иконки
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: textColor ?? theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      dense: false, // Убираем dense для большего пространства
    );
  }

  Widget _buildBiometricSection(BuildContext context, ThemeData theme) {
    return BlocBuilder<SecurityCubit, SecurityState>(
      builder: (context, state) {
        // Если биометрия недоступна, скрываем всю секцию
        if (state is SecurityBiometricNotAvailable) {
          return const SizedBox.shrink();
        }

        // В остальных случаях (доступна, загружается, ошибка и т.д.) строим секцию
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0),
                child: Text(
                  'Безопасность', // Заголовок для секции
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BlocBuilder<SecurityCubit, SecurityState>(
                builder: (context, consumerState) {
                  log("CustomDrawer Biometric State Builder: ${consumerState.runtimeType}");
                  bool currentSwitchValue = false;
                  bool isSwitchInteractive = true;
                  String subtitleText = 'Биометрия'; // По умолчанию

                  if (consumerState is SecurityBiometricAvailable) {
                    currentSwitchValue = consumerState.isEnabled;
                    subtitleText = consumerState.isEnabled ? 'Включено' : 'Выключено';
                  } else if (consumerState is SecurityBiometricPreferenceSaved) {
                    currentSwitchValue = consumerState.isEnabled;
                    subtitleText = consumerState.isEnabled ? 'Включено' : 'Выключено';
                  } else if (consumerState is SecurityBiometricPreferenceFailure) {
                    subtitleText = 'Ошибка';
                  } else {
                    // Для SecurityInitial, SecurityLoading и других непредусмотренных состояний
                    currentSwitchValue = false;
                    isSwitchInteractive = false; // Неактивен, пока состояние не определено
                    subtitleText = 'Выключено'; // или 'Загрузка...' если хотите
                  }

                  return Material(
                    color: Colors.transparent,
                    child: SettingsToggleCard(
                      title: 'Вход по биометрии',
                      subtitle: subtitleText,
                      value: currentSwitchValue,
                      onChanged: isSwitchInteractive
                          ? (value) {
                              context.read<SecurityCubit>().saveBiometricPreference(value);
                            }
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogoutSection(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        const Divider(indent: 16, endIndent: 16),
        _buildDrawerItem(
          context: context,
          icon: Icons.exit_to_app_rounded,
          title: 'Выход',
          iconColor: theme.colorScheme.error,
          textColor: theme.colorScheme.error,
          onTap: () => _showLogoutConfirmationDialog(context),
        ),
        const SizedBox(height: 16), // Отступ снизу
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    // final l10n = context.l10n; // Убираем l10n
    AppAlert.showConfirmDialog(
      context: context,
      title: 'Выход',
      content: Text('Вы уверены, что хотите выйти?', // Более полный текст
          style: Theme.of(context).textTheme.bodyMedium),
      cancelText: 'Отмена', // Более стандартный текст
      confirmText: 'Выйти', // Более явный текст
      cancelPressed: () => Navigator.pop(context),
      confirmPressed: () {
        Navigator.pop(context);
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.pop(context);
        }
        context.read<SignInCubit>().logout().then((_) {
          if (context.mounted) {
            context.router.pushAndPopUntil(
              const SignInRoute(),
              predicate: (_) => false,
            );
          }
        }).catchError((error) {
          log("Error during logout: $error");
          if (context.mounted) {
            showToast("Ошибка при выходе: $error", isError: true);
          }
        });
      },
    );
  }
}
