import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatefulWidget {
  final UserEntities? user;
  const SignUpForm({super.key, this.user});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool toc = false;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!toc) {
      showToast('Пожалуйста, примите условия использования', isError: true);
      return;
    }

    if (_formKey.currentState!.validate()) {
      final phone = widget.user?.phone;
      if (phone == null || phone.isEmpty) {
        showToast('Ошибка: номер телефона отсутствует', isError: true);
        return;
      }

      final user = UserEntities(
        userName: _usernameController.text,
        password: _passwordController.text,
        phone: phone,
      );
      context.read<SignUpCubit>().signUpUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          context.router.push(const SignUpSucces());
        } else if (state is SignUpFailure) {
          showToast(state.message, isError: true);
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 100,
              height: 100,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 40),
            const Text(
              'Регистрация',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// Имя пользователя
            CustomInputWidget(
              filledColor: theme.colorScheme.surface,
              hintText: 'Ваше имя',
              controller: _usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите имя';
                } else if (value.length < 3) {
                  return 'Имя должно содержать минимум 3 символа';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            /// Пароль
            CustomInputWidget(
              filledColor: theme.colorScheme.surface,
              hintText: 'Пароль',
              controller: _passwordController,
              isPasswordField: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите пароль';
                } else if (value.length < 6) {
                  return 'Пароль должен содержать минимум 6 символов';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            /// Подтверждение пароля
            CustomInputWidget(
              filledColor: theme.colorScheme.surface,
              hintText: 'Подтвердите пароль',
              controller: _confirmPasswordController,
              isPasswordField: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, подтвердите пароль';
                } else if (value != _passwordController.text) {
                  return 'Пароли не совпадают';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            /// Условия
            Row(
              children: [
                Checkbox(
                  value: toc,
                  onChanged: (v) => setState(() => toc = v ?? true),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => AppLaunch.launchURL(AppConst.terms),
                    child: Text(
                      'Я согласен с условиями использования',
                      maxLines: 3,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Кнопка регистрации
            BlocBuilder<SignUpCubit, SignUpState>(
              builder: (context, state) {
                return SubmitButtonWidget(
                  isLoading: state is SignUpLoading,
                  textStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  bgColor: theme.colorScheme.primary,
                  title: 'Зарегистрироваться',
                  onTap: _handleSubmit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
