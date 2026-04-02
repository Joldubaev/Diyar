import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import 'package:diyar/features/auth/presentation/widgets/otp_verification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SignInOtpPage extends StatefulWidget {
  final String phone;

  const SignInOtpPage({super.key, required this.phone});

  @override
  State<SignInOtpPage> createState() => _SignInOtpPageState();
}

class _SignInOtpPageState extends State<SignInOtpPage>
    with TimerMixin<SignInOtpPage> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeTimer();
  }

  @override
  void dispose() {
    disposeTimer();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SignInCubit>(),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccessWithUser) {
            final role =
                di.sl<LocalStorage>().getString(AppConst.userRole);
            final route = role == 'Courier'
                ? const CurierRoute()
                : const MainHomeRoute();
            context.router.pushAndPopUntil(route, predicate: (_) => false);
          } else if (state is SignInFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            _codeController.clear();
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(elevation: 0),
              body: OtpVerificationWidget(
                phone: widget.phone,
                codeController: _codeController,
                onCodeCompleted: (code) {
                  context
                      .read<SignInCubit>()
                      .verifySmsCodeForLogin(widget.phone, code);
                },
                onResendCode: () {
                  startTimer();
                  context
                      .read<SignInCubit>()
                      .sendSmsCodeForLogin(widget.phone);
                },
                timerHasEnded: timerHasEnded,
                secondsRemaining: startSeconds,
              ),
            );
          },
        ),
      ),
    );
  }
}
