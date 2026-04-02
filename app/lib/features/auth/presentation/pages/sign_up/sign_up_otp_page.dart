import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import 'package:diyar/features/auth/presentation/widgets/otp_verification_widget.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SignUpOtpPage extends StatefulWidget {
  final UserEntities user;

  const SignUpOtpPage({super.key, required this.user});

  @override
  State<SignUpOtpPage> createState() => _SignUpOtpPageState();
}

class _SignUpOtpPageState extends State<SignUpOtpPage>
    with TimerMixin<SignUpOtpPage> {
  final _codeController = TextEditingController();
  late final SignUpCubit _cubit;
  StreamSubscription<SignUpState>? _sub;

  @override
  void initState() {
    super.initState();
    initializeTimer();
    _cubit = di.sl<SignUpCubit>()
      ..sendVerificationCode(widget.user.phone);
    _sub = _cubit.stream.listen(_onState);
  }

  void _onState(SignUpState state) {
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
    _sub?.cancel();
    disposeTimer();
    _codeController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: OtpVerificationWidget(
        phone: widget.user.phone,
        codeController: _codeController,
        onCodeCompleted: (code) {
          _cubit.verifyCode(widget.user.phone, code);
        },
        onResendCode: () {
          startTimer();
          _cubit.sendVerificationCode(widget.user.phone);
        },
        timerHasEnded: timerHasEnded,
        secondsRemaining: startSeconds,
      ),
    );
  }
}
