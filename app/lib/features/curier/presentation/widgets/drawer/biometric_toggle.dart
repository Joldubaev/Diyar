import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'biometric_ui_mapper.dart';

class BiometricToggle extends StatelessWidget {
  const BiometricToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        final data = BiometricUiMapper.map(state);

        return SettingsToggleCard(
          title: 'Вход по биометрии',
          subtitle: data.subtitle,
          value: data.value,
          onChanged: data.enabled
              ? (v) => context.read<SignInCubit>().saveBiometricPreference(v)
              : null,
        );
      },
    );
  }
}
