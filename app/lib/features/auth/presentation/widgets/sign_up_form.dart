import 'package:auto_route/auto_route.dart';
import '../../../../core/launch/launch.dart';
import '../../../../shared/constants/app_const/app_const.dart';
import '../../../../shared/utils/show/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/routes.gr.dart';
import '../../../features.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/theme/theme.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

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
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: <Widget>[
          Image.asset(
            'assets/images/app_logo.png',
            width: 100,
            height: 100,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.center,
            child: Text(
              context.l10n.registration,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 20),
          CustomInputWidget(
            filledColor: theme.colorScheme.surface,
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
            hintText: '+996',
            filledColor: theme.colorScheme.surface,
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
            filledColor: theme.colorScheme.surface,
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
              Checkbox(
                value: toc,
                onChanged: (v) {
                  setState(() {
                    toc = v ?? true;
                  });
                },
              ),
              Expanded(
                child: TextButton(
                  child: Text(
                    context.l10n.termsAgree,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: theme.colorScheme.onPrimary),
                bgColor: theme.colorScheme.primary,
                title: context.l10n.register,
                onTap: () {
                  if (!toc) {
                    showToast(
                      context.l10n.termsAccept,
                      isError: true,
                    );
                  } else if (_formKey.currentState!.validate()) {
                    context.pushRoute(
                      SignUpOtpRoute(
                        user: UserModel(
                            name: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            phone: _phoneController.text),
                      ),
                    );
                  }
                },
              );
            },
          ),
          const SizedBox(height: 20),
          TextCheckButton(
            text: context.l10n.alreadyHaveAccount,
            route: context.l10n.login,
            onPressed: () {
              context.pushRoute(const SignInRoute());
            },
          ),
        ],
      ),
    );
  }
}
