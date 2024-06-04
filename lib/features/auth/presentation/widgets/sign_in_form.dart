import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/injection_container.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/shared/constants/app_const/app_const.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/show/bottom_sheet.dart';
import 'package:diyar/shared/utils/snackbar/snackbar_message.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final resedPasswordCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final bottomPadding = viewInsets.bottom;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomInputWidget(
                title: context.l10n.email,
                hintText: context.l10n.email,
                controller: _usernameController,
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
              CustomInputWidget(
                title: context.l10n.password,
                hintText: "******",
                controller: _passwordController,
                isPasswordField: true,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.l10n.pleaseEnterPassword;
                  } else if (value.length < 5) {
                    return context.l10n.pleaseEnterCorrectPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              BlocConsumer<SignInCubit, SignInState>(
                listener: (context, state) {
                  if (state is SignInSuccessWithUser) {
                    var role =
                        sl<SharedPreferences>().getString(AppConst.userRole);
                    if (role?.toLowerCase() == "user".toLowerCase()) {
                      context.router.pushAndPopUntil(const MainRoute(),
                          predicate: (_) => false);
                    } else {
                      context.router.pushAndPopUntil(const CurierRoute(),
                          predicate: (_) => false);
                    }
                  }
                },
                builder: (context, state) {
                  return SubmitButtonWidget(
                    textStyle: theme.textTheme.bodyLarge!
                        .copyWith(color: AppColors.white),
                    bgColor: AppColors.primary,
                    isLoading: state is SignInLoading,
                    title: 'Авторизоваться',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInCubit>().signInUser(UserModel(
                            email: _usernameController.text,
                            password: _passwordController.text));
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
                        message: context.l10n.notAvailable, context: context);
                  }),
              TextCheckButton(
                text: context.l10n.notHaveAccount,
                route: context.l10n.register,
                onPressed: () {
                  context.pushRoute(const SignUpRoute());
                },
              ),
              TextButton(
                onPressed: () {
                  AppBottomSheet.showBottomSheet(
                    initialChildSize: 0.7,
                    context,
                    AuthBottomSheet(resedPasswordCode: resedPasswordCode),
                  );
                },
                child: Text(context.l10n.forgotPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
