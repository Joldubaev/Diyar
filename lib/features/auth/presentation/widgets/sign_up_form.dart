import 'package:auto_route/auto_route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/snackbar/snackbar_message.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController(text: '+996');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomInputWidget(
            title: context.l10n.yourName,
            hintText: context.l10n.nameExample,
            controller: _usernameController,
            validator: (value) {
              if (value!.isEmpty) {
                return context.l10n.pleaseEnterName;
              } else if (value.length < 3) {
                return context.l10n.pleaseEnterCorrectName;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
            title: context.l10n.email,
            hintText: context.l10n.emailExample,
            controller: _emailController,
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
          const SizedBox(height: 10),
          PhoneNumberMask(
            title: context.l10n.phone,
            hintText: '+996 (___) __-__-__',
            textController: _phoneController,
            hint: context.l10n.phone,
            formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
            textInputType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return context.l10n.pleaseEnterPhone;
              } else if (value.length < 10) {
                return context.l10n.pleaseEnterCorrectPhone;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
            title: context.l10n.password,
            hintText: "********",
            controller: _passwordController,
            isPasswordField: true,
            validator: (value) {
              if (value!.isEmpty) {
                return context.l10n.pleaseEnterPassword;
              } else if (value.length < 5) {
                return context.l10n.pleaseEnterCorrectPassword;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
            title: context.l10n.confirmPassword,
            hintText: "********",
            controller: _confirmPasswordController,
            isPasswordField: true,
            validator: (value) {
              if (value!.isEmpty) {
                return context.l10n.confirmPassword;
              } else if (value != _passwordController.text) {
                return context.l10n.passwordsDoNotMatch;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          BlocConsumer<SignUpCubit, SignUpState>(
            listener: (_, state) {
              if (state is SignUpSuccess) {
                context.router.pushAndPopUntil(
                  const SignUpSucces(),
                  predicate: (_) => false,
                );
              }
            },
            builder: (context, state) {
              return SubmitButtonWidget(
                isLoading: state is SignUpLoading,
                textStyle: theme.textTheme.bodyLarge!.copyWith(color: AppColors.white),
                bgColor: AppColors.primary,
                title: context.l10n.register,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<SignUpCubit>(context).signUpUser(
                      UserModel(
                        name: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        phone: _phoneController.text,
                      ),
                    );
                  }
                },
              );
            },
          ),
          const LineOrWidget(),
          GoogleButton(
            color: AppColors.primary,
            onPressed: () {
              SnackBarMessage().showErrorSnackBar(
                message: context.l10n.notAvailableTry,
                context: context,
              );
            },
          ),
          TextCheckButton(
            text: context.l10n.alreadyHaveAccount,
            route: context.l10n.entrance,
            onPressed: () {
              context.pushRoute(const SignInRoute());
            },
          ),
        ],
      ),
    );
  }
}
