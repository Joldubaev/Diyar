import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/auth/domain/entities/reset_password_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class RessetPasswordPage extends StatefulWidget {
  final String? phone;
  const RessetPasswordPage({super.key, this.phone});

  @override
  State<RessetPasswordPage> createState() => _RessetPasswordPageState();
}

class _RessetPasswordPageState extends State<RessetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final resedPasswordCode = TextEditingController();
  bool _isNavigated = false;

  @override
  void initState() {
    _phoneController.text = widget.phone ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.colorScheme.onPrimary,
          ),
          onPressed: () => context.router.push(const SignInRoute()),
        ),
        title: Text(
          context.l10n.passwordRecovery,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: theme.colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Image(
                height: 100,
                width: 100,
                color: theme.colorScheme.primary,
                image: const AssetImage("assets/images/auth_images.png"),
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.passwordRecoveryText,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
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
              CustomInputWidget(
                filledColor: theme.colorScheme.surface,
                title: context.l10n.newPassword,
                hintText: "******",
                controller: _passwordController,
                isPasswordField: true,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.l10n.pleaseEnterPassword;
                  } else if (value.length < 6) {
                    return context.l10n.pleaseEnterCorrectPassword;
                  }
                  return null;
                },
              ),
              CustomInputWidget(
                filledColor: theme.colorScheme.surface,
                title: context.l10n.confirmPassword,
                hintText: "******",
                controller: _confirmPasswordController,
                isPasswordField: true,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.l10n.enterPassword;
                  } else if (value != _passwordController.text) {
                    return context.l10n.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
              CustomInputWidget(
                filledColor: theme.colorScheme.surface,
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
                  if (state is ResetPasswordSuccess) {
                    if (!_isNavigated) {
                      _isNavigated = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.router.pushAndPopUntil(const SignInRoute(), predicate: (_) => false);
                      });
                      showToast(context.l10n.passwordChanged, isError: false);
                    }
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
                            '${context.l10n.error} ${state.message}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: const Color.fromARGB(255, 233, 71, 35), fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SubmitButtonWidget(
                          textStyle:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                          bgColor: theme.colorScheme.primary,
                          title: context.l10n.entrance,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInCubit>().resetPassword(
                                    ResetPasswordEntity(
                                      phone: _phoneController.text,
                                      newPassword: _passwordController.text,
                                      code: int.parse(resedPasswordCode.text),
                                    ),
                                  );
                            }
                          },
                        ),
                      ],
                    );
                  }

                  return SubmitButtonWidget(
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                    bgColor: theme.colorScheme.primary,
                    title: context.l10n.entrance,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInCubit>().resetPassword(
                              ResetPasswordEntity(
                                phone: _phoneController.text,
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
