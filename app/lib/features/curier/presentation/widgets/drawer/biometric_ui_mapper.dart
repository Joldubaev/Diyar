import 'package:diyar/features/auth/auth.dart';

class BiometricUiData {
  final bool value;
  final bool enabled;
  final String subtitle;

  const BiometricUiData({
    required this.value,
    required this.enabled,
    required this.subtitle,
  });
}

class BiometricUiMapper {
  static BiometricUiData map(SignInState state) {
    return switch (state) {
      BiometricAvailable(:final isBiometricEnabled) => BiometricUiData(
          value: isBiometricEnabled,
          enabled: true,
          subtitle: isBiometricEnabled ? 'Включено' : 'Выключено',
        ),

      BiometricPreferenceSaved(:final isEnabled) => BiometricUiData(
          value: isEnabled,
          enabled: true,
          subtitle: isEnabled ? 'Включено' : 'Выключено',
        ),

      BiometricAuthenticating() => const BiometricUiData(
          value: false,
          enabled: false,
          subtitle: 'Проверка...',
        ),

      BiometricAuthenticationFailure() => const BiometricUiData(
          value: false,
          enabled: false,
          subtitle: 'Ошибка',
        ),

      BiometricPreferenceFailure() => const BiometricUiData(
          value: false,
          enabled: true,
          subtitle: 'Ошибка',
        ),

      _ => const BiometricUiData(
          value: false,
          enabled: false,
          subtitle: 'Выключено',
        ),
    };
  }
}
