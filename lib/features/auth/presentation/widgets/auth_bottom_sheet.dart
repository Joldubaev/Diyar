import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBottomSheet extends StatelessWidget {
  const AuthBottomSheet({super.key, required this.resedPasswordCode});

  final TextEditingController resedPasswordCode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.enterEmail),
          const SizedBox(height: 10),
          CustomInputWidget(
            filledColor: Theme.of(context).colorScheme.surface,
            title: context.l10n.email,
            hintText: context.l10n.email,
            controller: resedPasswordCode,
            isPasswordField: false,
            inputType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return context.l10n.pleaseEnterEmail;
              } else if (!EmailValidator.validate(value)) {
                return context.l10n.pleaseEnterCorrectEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SubmitButtonWidget(
            textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            bgColor: Theme.of(context).colorScheme.primary,
            title: context.l10n.send,
            onTap: () {
              if (resedPasswordCode.text.isNotEmpty &&
                  EmailValidator.validate(resedPasswordCode.text)) {
                context
                    .read<SignInCubit>()
                    .sendCodeToEmail(resedPasswordCode.text);
                context.router.replace(const RessetPasswordRoute());
              } else {
                SnackBarMessage().showErrorSnackBar(
                  message: context.l10n.pleaseEnterCorrectEmail,
                  context: context,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
