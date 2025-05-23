import 'package:auto_route/annotations.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:developer';

@RoutePage()
class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  void initState() {
    super.initState();
    context.read<SignInCubit>().checkBiometricsAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Безопасность'),
        ),
        body: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            log("SecurityPage State: ${state.runtimeType}");
            if (state is BiometricPreferenceFailure) {
              showToast("Ошибка: ${state.message}", isError: true);
            }
          },
          builder: (context, state) {
            bool isBiometricSwitchEnabled = false;
            bool currentBiometricValue = false;
            String subtitle = 'Включить / Выключить';

            if (state is BiometricAvailable) {
              isBiometricSwitchEnabled = true;
              currentBiometricValue = state.isBiometricEnabled;
            } else if (state is BiometricNotAvailable) {
              isBiometricSwitchEnabled = false;
              currentBiometricValue = false;
              subtitle = 'Биометрия недоступна на устройстве';
            } else if (state is BiometricPreferenceSaved) {
              isBiometricSwitchEnabled = true;
              currentBiometricValue = state.isEnabled;
            } else if (state is BiometricInitial || state is BiometricAuthenticating) {
              isBiometricSwitchEnabled = false;
              subtitle = 'Проверка доступности...';
            }

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsToggleCard(
                    title: 'Вход по биометрии',
                    subtitle: subtitle,
                    value: currentBiometricValue,
                    onChanged: isBiometricSwitchEnabled
                        ? (value) {
                            context.read<SignInCubit>().saveBiometricPreference(value);
                          }
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildDeleteAccountButton(context),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SettingsTile(
        leading: SvgPicture.asset(
          'assets/icons/delete_a.svg',
          height: 40,
        ),
        text: 'Удалить аккаунт',
        onPressed: () => _showDeleteConfirmation(context),
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    AppAlert.showConfirmDialog(
      context: context,
      title: 'Удалить',
      content: const Text('Вы уверены что хотите удалить аккаунт?'),
      cancelText: context.l10n.no,
      confirmText: context.l10n.yes,
      cancelPressed: () => Navigator.pop(context),
      confirmPressed: () => context.read<ProfileCubit>().deleteUser(),
    );
  }
}
