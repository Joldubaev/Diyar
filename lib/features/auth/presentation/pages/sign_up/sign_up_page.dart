import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:diyar/features/auth/presentation/presentation.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SignUpForm(),
      ),
    );
  }
}
