import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/data/models/user_model.dart';
import 'package:diyar/features/auth/presentation/cubit/cubit.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class SignUpOtpPage extends StatefulWidget {
  final UserModel user;

  const SignUpOtpPage({super.key, required this.user});

  @override
  State<SignUpOtpPage> createState() => _SignUpOtpPageState();
}

class _SignUpOtpPageState extends State<SignUpOtpPage> {
  Timer? _timer;
  int _start = 59;
  bool isTimeEnd = false;
  bool isLoading = false;

  String code = generateOtpCode();

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 1) {
          setState(() {
            timer.cancel();
            isTimeEnd = true;
          });
        } else {
          setState(() {
            isTimeEnd = false;
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    context.read<SignUpCubit>().sendRegisterSms(
          code: code,
          phone: widget.user.phone!.replaceAll("+", ''),
        );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: BlocConsumer<SignUpCubit, SignUpState>(listener: (context, state) {
        if (state is SignUpSuccess) {
          context.router.pushAndPopUntil(
            const SignUpSucces(),
            predicate: (_) => false,
          );
        } else if (state is SmsSignUpError) {
          showToast("Пожалуйста, попробуйте позже!", isError: true);
          context.maybePop();
        }
      }, builder: (context, state) {
        if (state is SmsSignUpLoading) {
          return const LoadingWidget();
        }

        return PopScope(
          // canPop: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Введите код ',
                    style: TextStyle(
                      color: Color(0xFF3D3D3D),
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Мы отправили вам код на указанный номер телефона.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFB1B1B1),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.user.phone!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Pinput(
                    length: 6,
                    onCompleted: (value) {
                      if (value == code) {
                        context.read<SignUpCubit>().signUpUser(widget.user);
                      } else {
                        showToast(
                          "Пожалуйста, введите правильный код.",
                          isError: true,
                        );
                      }
                    },
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(234, 239, 243, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      if (!isTimeEnd)
                        Column(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                "Повторная генерация доступно через",
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "$_start сек",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      if (isTimeEnd)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _start = 59;
                              code = generateOtpCode();
                            });
                            startTimer();
                            context.read<SignUpCubit>().sendRegisterSms(
                                  code: code,
                                  phone: widget.user.phone!.replaceAll("+", ''),
                                );
                          },
                          child: Text(
                            "Переотправить код",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
