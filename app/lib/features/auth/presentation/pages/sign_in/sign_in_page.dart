import '../../../../../core/router/routes.gr.dart';
import '../../../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../presentation.dart';

@RoutePage()
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(context.l10n.authorize,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            AutoRouter.of(context).replace(const MainRoute());
          },
        ),
      ),
      body: const SafeArea(
        child: LoginForm(),
      ),
    );
  }
}
