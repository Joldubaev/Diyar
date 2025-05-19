import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom - kToolbarHeight - 40,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    Image(
                      height: 150,
                      width: 150,
                      color: theme.colorScheme.primary,
                      image: const AssetImage("assets/images/auth_images.png"),
                    ),
                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.center,
                        child: Text(context.l10n.welcome, style: Theme.of(context).textTheme.titleLarge)),
                    const SizedBox(height: 20),
                    CustomInputWidget(
                      hintText: '+996',
                      filledColor: theme.colorScheme.surface,
                      controller: _phoneController,
                      inputType: TextInputType.phone,
                     phoneFormatType: PhoneFormatType.withPlus,
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
                              AuthBottomSheet(resetPasswordPhone: resedPasswordCode),
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
                  ],
                ),
                Column(
                  children: [
                    BlocConsumer<SignInCubit, SignInState>(
                      listener: (context, state) {
                        if (state is SignInFailure) {
                          SnackBarMessage().showErrorSnackBar(
                            message: state.message,
                            context: context,
                          );
                        } else if (state is SignInSuccessWithUser) {
                          context.router.pushAndPopUntil(
                            const SetNewPinCodeRoute(),
                            predicate: (route) => false,
                          );
                        }
                      },
                      builder: (context, state) {
                        return SubmitButtonWidget(
                          textStyle:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                          bgColor: theme.colorScheme.primary,
                          isLoading: state is SignInLoading,
                          title: context.l10n.authorize,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInCubit>().signIn(
                                    UserEntities(
                                      phone: _phoneController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            }
                          },
                        );
                      },
                    ),
                    TextCheckButton(
                      text: context.l10n.notHaveAccount,
                      route: context.l10n.register,
                      onPressed: () {
                        context.pushRoute(CheckPhoneNumberRoute());
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
