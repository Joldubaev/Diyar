import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/shared/theme/theme.dart';
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
      body: SafeArea(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Image(
                height: 100,
                width: 100,
                color: AppColors.primary,
                image: AssetImage("assets/images/auth_images.png"),
              ),
            ),
            const SizedBox(height: 10),
            Center(child: Text(context.l10n.entrance, style: theme.textTheme.titleLarge)),
            const SizedBox(height: 10),
            const LoginForm(),
          ],
        ),
      ),
    );
  }
}
