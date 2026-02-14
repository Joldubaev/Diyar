import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final resedPasswordCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  child: Text(
                    context.l10n.welcome,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 20),
                CustomInputWidget(
                  hintText: '996',
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
            const SizedBox(height: 40),
            Column(
              children: [
                BlocConsumer<SignInCubit, SignInState>(
                  listener: (context, state) {
                    if (state is SignInFailure) {
                      SnackBarMessage().showErrorSnackBar(
                        message: state.message,
                        context: context,
                      );
                    } else if (state is SmsCodeSentForLogin) {
                      context.router.push(
                        SignInOtpRoute(phone: state.phone),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SubmitButtonWidget(
                      textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                      bgColor: theme.colorScheme.primary,
                      isLoading: state is SignInLoading,
                      title: context.l10n.authorize,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          final phone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
                          final formattedPhone = phone.startsWith('996') ? phone : '996$phone';
                          context.read<SignInCubit>().sendSmsCodeForLogin(formattedPhone);
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
    );
  }
}
