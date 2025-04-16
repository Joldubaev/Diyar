import 'package:auto_route/auto_route.dart';
import '../../../../core/router/routes.gr.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/components/components.dart';
import '../../../features.dart';
import '../../../../shared/constants/app_const/app_const.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/utils/show/bottom_sheet.dart';
import '../../../../shared/utils/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final resedPasswordCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Image(
            height: 100,
            width: 100,
            color: theme.colorScheme.primary,
            image: const AssetImage("assets/images/auth_images.png"),
          ),
          const SizedBox(height: 40),
          Align(
              alignment: Alignment.center,
              child: Text(context.l10n.welcome,
                  style: Theme.of(context).textTheme.titleLarge)),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          CustomInputWidget(
            filledColor: theme.colorScheme.surface,
            hintText: context.l10n.password,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  AppBottomSheet.showBottomSheet(
                    initialChildSize: 0.7,
                    context,
                    AuthBottomSheet(resedPasswordCode: resedPasswordCode),
                  );
                },
                child: Text(
                  context.l10n.forgotPassword,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          BlocConsumer<SignInCubit, SignInState>(
            listener: (context, state) {
              if (state is SignInFailure) {
                SnackBarMessage().showErrorSnackBar(
                  message: context.l10n.loginError,
                  context: context,
                );
              } else if (state is SignInSuccessWithUser) {
                var role = sl<SharedPreferences>().getString(AppConst.userRole);
                if (role?.toLowerCase() == "user".toLowerCase()) {
                  context.router.pushAndPopUntil(
                    const MainRoute(),
                    predicate: (_) => false,
                  );
                } else {
                  context.router.pushAndPopUntil(
                    const CurierRoute(),
                    predicate: (_) => false,
                  );
                }
              }
            },
            builder: (context, state) {
              return SubmitButtonWidget(
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: theme.colorScheme.onPrimary),
                bgColor: theme.colorScheme.primary,
                isLoading: state is SignInLoading,
                title: context.l10n.authorize,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<SignInCubit>().signInUser(
                          UserModel(
                            phone: _phoneController.text,
                            password: _passwordController.text,
                          ),
                        );
                  }
                },
              );
            },
          ),
          const SizedBox(height: 20),
          TextCheckButton(
            text: context.l10n.notHaveAccount,
            route: context.l10n.register,
            onPressed: () {
              context.pushRoute(const SignUpRoute());
            },
          ),
        ],
      ),
    );
  }
}
