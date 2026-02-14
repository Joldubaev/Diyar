import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CheckPhoneNumberPage extends StatefulWidget {
  const CheckPhoneNumberPage({super.key});

  @override
  State<CheckPhoneNumberPage> createState() => _CheckPhoneNumberPageState();
}

class _CheckPhoneNumberPageState extends State<CheckPhoneNumberPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is CheckPhoneFailure) {
          SnackBarMessage().showErrorSnackBar(
            message: state.message,
            context: context,
          );
        } else if (state is CheckPhoneSuccess) {
          context.router.push(
            SignUpOtpRoute(
              user: UserEntities(phone: _phoneController.text),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        width: 120,
                        height: 120,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Введите номер телефона',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Мы отправим код подтверждения',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    CustomInputWidget(
                      hintText: '+996',
                      filledColor: theme.colorScheme.surface,
                      controller: _phoneController,
                      inputType: TextInputType.phone,
                      phoneFormatType: PhoneFormatType.withPlus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите номер телефона';
                        } else if (value.length < 10) {
                          return 'Номер должен содержать 10 цифр';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextCheckButton(
                      text: 'Уже есть аккаунт?',
                      route: 'Войти',
                      onPressed: () => context.pushRoute(const SignInRoute()),
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<SignUpCubit, SignUpState>(
                      builder: (context, state) {
                        return SubmitButtonWidget(
                          isLoading: state is CheckPhoneLoading,
                          bgColor: theme.colorScheme.primary,
                          onTap: state is CheckPhoneLoading
                              ? LoadingAdaptive.new
                              : () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    context.read<SignUpCubit>().checkPhoneNumber(
                                          _phoneController.text,
                                        );
                                  }
                                },
                          title: 'Продолжить',
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
