import 'package:diyar/features/auth/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'biometric_toggle.dart';

class DrawerBiometricSection extends StatelessWidget {
  const DrawerBiometricSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        if (state is BiometricNotAvailable) return const SizedBox.shrink();
        return const BiometricToggle();
      },
    );
  }
}
