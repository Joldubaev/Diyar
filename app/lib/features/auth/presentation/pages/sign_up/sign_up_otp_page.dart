import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class SignUpOtpPage extends StatefulWidget {
  final UserEntities user;

  const SignUpOtpPage({super.key, required this.user});

  @override
  State<SignUpOtpPage> createState() => _SignUpOtpPageState();
}

class _SignUpOtpPageState extends State<SignUpOtpPage> {
  Timer? _timer;
  int _start = 59;
  bool isTimeEnd = false;
  final _codeController = TextEditingController();

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
    // context.read<SignUpCubit>().sendVerificationCode(widget.user.phone);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is VerifyCodeSuccess) {
          context.router.push(
            SignUpRoute(user: widget.user),
          );
        } else if (state is VerifyCodeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Введите код',
                  style: TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Мы отправили код подтверждения на ваш номер',
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
                  widget.user.phone,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 35),
                Pinput(
                  length: 6,
                  controller: _codeController,
                  onCompleted: (value) {
                    context.read<SignUpCubit>().verifyCode(
                          widget.user.phone,
                          value,
                        );
                  },
                  defaultPinTheme: const PinTheme(
                    width: 60,
                    height: 50,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: Color.fromRGBO(234, 239, 243, 1),
                          width: 1,
                        ),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  children: [
                    if (!isTimeEnd)
                      Column(
                        children: [
                          const SizedBox(
                            width: 150,
                            child: Text(
                              'Повторная отправка будет доступна через',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "$_start сек",
                            style: const TextStyle(
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
                          });
                          startTimer();
                          // context.read<SignUpCubit>().sendVerificationCode(widget.user.phone);
                        },
                        child: const Text(
                          'Отправить код повторно',
                          style: TextStyle(
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
      ),
    );
  }
}
