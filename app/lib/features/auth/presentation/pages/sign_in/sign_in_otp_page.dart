import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class SignInOtpPage extends StatefulWidget {
  final String phone;

  const SignInOtpPage({
    super.key,
    required this.phone,
  });

  @override
  State<SignInOtpPage> createState() => _SignInOtpPageState();
}

class _SignInOtpPageState extends State<SignInOtpPage> with TimerMixin<SignInOtpPage> {
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

  Widget _buildTimerSection(BuildContext context) {
    if (timerHasEnded) {
      return TextButton(
        onPressed: () {
          startTimer();
          context.read<SignInCubit>().sendSmsCodeForLogin(widget.phone);
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
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccessWithUser) {
          final role = sl<LocalStorage>().getString(AppConst.userRole);
          final targetRoute = role == "Courier" ? const CurierRoute() : const MainRoute();
          context.router.pushAndPopUntil(targetRoute, predicate: (_) => false);
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
                  widget.phone,
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
                    context.read<SignInCubit>().verifySmsCodeForLogin(
                          widget.phone,
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
