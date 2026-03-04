import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SignInCubit>(),
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const SafeArea(
        child: SignInForm(),
      ),
    ),
    );
  }
}
