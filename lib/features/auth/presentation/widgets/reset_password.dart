import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class RessetPasswordPage extends StatefulWidget {
  const RessetPasswordPage({super.key});

  @override
  State<RessetPasswordPage> createState() => _RessetPasswordPageState();
}

class _RessetPasswordPageState extends State<RessetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final resedPasswordCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
            onPressed: () => context.router.push(const SignInRoute())),
        title: Text(
          context.l10n.passwordRecovery,
          style: theme.textTheme.titleSmall!.copyWith(color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Image(
                height: 100,
                width: 100,
                color: AppColors.primary,
                image: AssetImage("assets/images/auth_images.png"),
              ),
              const SizedBox(height: 10),
              Text(context.l10n.passwordRecoveryText,
                  style: theme.textTheme.bodyLarge!.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              CustomInputWidget(
                title: context.l10n.email,
                hintText: context.l10n.email,
                controller: _emailController,
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
                title: context.l10n.newPassword,
                hintText: "******",
                controller: _passwordController,
                isPasswordField: true,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.l10n.pleaseEnterCode;
                  } else if (value.length < 5) {
                    return context.l10n.pleaseEnterCorrectCode;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomInputWidget(
                title: context.l10n.codeUpdate,
                hintText: "******",
                controller: resedPasswordCode,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.l10n.pleaseEnterCode;
                  } else if (value.length < 5) {
                    return context.l10n.pleaseEnterCorrectCode;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              BlocConsumer<SignInCubit, SignInState>(
                listener: (context, state) {
                  if (state is SignInFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.red));
                  } else if (state is ResetPasswordSuccess) {
                    context.router.pushAndPopUntil(const MainRoute(), predicate: (_) => false);
                  }
                },
                builder: (context, state) {
                  if (state is SignInLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SignInFailure) {
                    return Column(
                      children: [
                        Center(
                          child: Text(
                            context.l10n.resgisterIsFailed,
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: const Color.fromARGB(255, 233, 71, 35), fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SubmitButtonWidget(
                          textStyle: theme.textTheme.bodyLarge!.copyWith(color: AppColors.white),
                          bgColor: AppColors.primary,
                          title: context.l10n.entrance,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInCubit>().resetPassword(
                                      model: ResetModel(
                                    email: _emailController.text,
                                    newPassword: _passwordController.text,
                                    code: int.parse(resedPasswordCode.text),
                                  ));
                            }
                          },
                        ),
                      ],
                    );
                  }

                  return SubmitButtonWidget(
                    textStyle: theme.textTheme.bodyLarge!.copyWith(color: AppColors.white),
                    bgColor: AppColors.primary,
                    title: context.l10n.entrance,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInCubit>().resetPassword(
                              model: ResetModel(
                                email: _emailController.text,
                                newPassword: _passwordController.text,
                                code: int.parse(resedPasswordCode.text),
                              ),
                            );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
