import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/launch/launch.dart';
import 'package:diyar/shared/constants/app_const/app_const.dart';
import 'package:diyar/shared/utils/show/bottom_sheet.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/shared/theme/theme.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool toc = false;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
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
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: <Widget>[
          Image.asset(
            'assets/images/app_logo.png',
            width: 100,
            height: 100,
            color: AppColors.primary,
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.center,
            child: Text(
              context.l10n.registration,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 20),
          CustomInputWidget(
            hintText: context.l10n.yourName,
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
            hintText: context.l10n.email,
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
          CustomInputWidget(
            hintText: '+996',
            filledColor: Colors.white,
            controller: _phoneController,
            inputType: TextInputType.phone,
            inputFormatters: [phoneFormatter],
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
            hintText: context.l10n.password,
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
          Row(
            children: [
              Expanded(
                child: Checkbox(
                  value: toc,
                  onChanged: (v) {
                    setState(() {
                      toc = v ?? true;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: TextButton(
                  child: Text(
                    'Я согласен(на) с условиями использования пользовательского соглашения',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: AppColors.blue,
                    ),
                    maxLines: 3,
                  ),
                  onPressed: () => AppLaunch.launchURL(AppConst.terms),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return SubmitButtonWidget(
                isLoading: state is SignUpLoading,
                textStyle:
                    theme.textTheme.bodyLarge!.copyWith(color: AppColors.white),
                bgColor: AppColors.primary,
                title: context.l10n.register,
                onTap: () {
                  if (!toc) {
                    showToast(
                      'Пожалуйста, примите условия пользовательского соглашения',
                      isError: true,
                    );
                  } else if (_formKey.currentState!.validate() &&
                      !context.read<SignUpCubit>().isNavigating) {
                    context.read<SignUpCubit>().isNavigating = true;
                    context
                        .pushRoute(
                      SignUpOtpRoute(
                        user: UserModel(
                          name: _usernameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          phone: _phoneController.text.replaceAll(' ', ''),
                        ),
                      ),
                    )
                        .then((_) {
                      context.read<SignUpCubit>().isNavigating =
                          false; // Reset the flag after navigation
                    });
                  }
                },
              );
            },
          ),
          const SizedBox(height: 20),
          TextCheckButton(
            text: context.l10n.alreadyHaveAccount,
            route: 'Войти',
            onPressed: () {
              context.pushRoute(const SignInRoute());
            },
          ),
        ],
      ),
    );
  }
}
