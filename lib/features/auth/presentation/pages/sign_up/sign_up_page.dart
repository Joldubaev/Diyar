import 'package:auto_route/annotations.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          children: [
            Center(
                child: Text(
              context.l10n.registration,
              style: theme.textTheme.titleMedium,
            )),
            const SizedBox(height: 10),
            const SignUpForm(),
          ],
        ),
      ),
    );
  }
}
