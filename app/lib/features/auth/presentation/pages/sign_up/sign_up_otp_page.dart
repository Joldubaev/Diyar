import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class SignUpOtpPage extends StatefulWidget {
  final UserEntities user;

  const SignUpOtpPage({
    super.key,
    required this.user,
  });

  @override
  State<SignUpOtpPage> createState() => _SignUpOtpPageState();
}

class _SignUpOtpPageState extends State<SignUpOtpPage> with TimerMixin<SignUpOtpPage> {
  final _codeController = TextEditingController();
  late final SignUpCubit _signUpCubit;
  StreamSubscription<SignUpState>? _stateSubscription;

  @override
  void initState() {
    super.initState();
    initializeTimer();
    _signUpCubit = di.sl<SignUpCubit>()
      ..sendVerificationCode(widget.user.phone);
    _stateSubscription = _signUpCubit.stream.listen(_onSignUpState);
  }

  void _onSignUpState(SignUpState state) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (state is VerifyCodeSuccess) {
        context.router.push(SignUpRoute(user: widget.user));
      } else if (state is VerifyCodeFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
        _codeController.clear();
      }
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    disposeTimer();
    _codeController.dispose();
    _signUpCubit.close();
    super.dispose();
  }

  Widget _buildTimerSection(BuildContext context) {
    if (timerHasEnded) {
      return TextButton(
        onPressed: () {
          startTimer();
          _signUpCubit.sendVerificationCode(widget.user.phone);
        },
        child: const Text(
          'Отправить код повторно',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Column(
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
          "$startSeconds сек",
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                style: _kTitleStyle,
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Мы отправили код подтверждения на ваш номер',
                  textAlign: TextAlign.center,
                  style: _kSubtitleStyle,
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
                  _signUpCubit.verifyCode(
                    widget.user.phone,
                    value,
                  );
                },
                defaultPinTheme: _kDefaultPinTheme,
              ),
              const SizedBox(height: 15),
              _buildTimerSection(context),
            ],
          ),
        ),
      ),
    );
  }
}

// ───── КОНСТАНТЫ СТИЛЕЙ ─────
const TextStyle _kTitleStyle = TextStyle(
  color: Color(0xFF3D3D3D),
  fontSize: 26,
  fontWeight: FontWeight.w700,
);

const TextStyle _kSubtitleStyle = TextStyle(
  color: Color(0xFFB1B1B1),
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

const PinTheme _kDefaultPinTheme = PinTheme(
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
        color: Colors.grey,
        width: 1,
      ),
    ),
    borderRadius: BorderRadius.all(Radius.circular(15)),
  ),
);
