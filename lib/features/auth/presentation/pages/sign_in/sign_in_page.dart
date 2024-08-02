import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/auth/presentation/presentation.dart';

@RoutePage()
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(context.l10n.authorize),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.maybePop())),
      body: const SafeArea(
        child: LoginForm(),
      ),
    );
  }
}
