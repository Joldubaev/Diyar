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
          dialogContext.router.maybePop();
          await context.router.push(CheckPhoneNumberRoute());
        },
        onLogin: () {
          dialogContext.router.maybePop();
          context.router.push(const SignInRoute());
        },
      );
    },
  );
}
