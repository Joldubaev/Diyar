import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

/// Показывает диалог «Регистрация / Авторизация» с переходами на экраны регистрации и входа.
Future<void> showRegistrationAlertDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return RegistrationAlertDialog(
        onRegister: () async {
          await dialogContext.router.pushAndPopUntil(
            CheckPhoneNumberRoute(),
            predicate: (route) => false,
          );
        },
        onLogin: () {
          dialogContext.router.pushAndPopUntil(
            const SignInRoute(),
            predicate: (route) => false,
          );
        },
      );
    },
  );
}
