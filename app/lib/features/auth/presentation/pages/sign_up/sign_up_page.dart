import 'package:auto_route/annotations.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  final UserEntities? user;
  const SignUpPage({super.key, this.user});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SignUpCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Регистрация'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SignUpForm(user: widget.user),
        ),
      ),
    );
  }
}
