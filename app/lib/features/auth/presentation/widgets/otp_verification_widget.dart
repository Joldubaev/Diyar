import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

/// Reusable OTP verification UI used by both sign-in and sign-up flows.
///
/// Extracts the shared layout (title, subtitle, phone display, Pinput,
/// timer) into a single widget. Callers provide callbacks for code
/// completion and resend actions.
class OtpVerificationWidget extends StatelessWidget {
  const OtpVerificationWidget({
    super.key,
    required this.phone,
    required this.codeController,
    required this.onCodeCompleted,
    required this.onResendCode,
    required this.timerHasEnded,
    required this.secondsRemaining,
  });

  final String phone;
  final TextEditingController codeController;
  final ValueChanged<String> onCodeCompleted;
  final VoidCallback onResendCode;
  final bool timerHasEnded;
  final int secondsRemaining;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const Text(
              'Мы отправили код подтверждения на ваш номер',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFB1B1B1),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              phone,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 35),
            Pinput(
              length: 6,
              controller: codeController,
              onCompleted: onCodeCompleted,
              defaultPinTheme: _kDefaultPinTheme,
            ),
            const SizedBox(height: 15),
            _TimerSection(
              timerHasEnded: timerHasEnded,
              secondsRemaining: secondsRemaining,
              onResend: onResendCode,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerSection extends StatelessWidget {
  const _TimerSection({
    required this.timerHasEnded,
    required this.secondsRemaining,
    required this.onResend,
  });

  final bool timerHasEnded;
  final int secondsRemaining;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    if (timerHasEnded) {
      return TextButton(
        onPressed: onResend,
        child: const Text(
          'Отправить код повторно',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
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
          '$secondsRemaining сек',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

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
      BorderSide(color: Colors.grey, width: 1),
    ),
    borderRadius: BorderRadius.all(Radius.circular(15)),
  ),
);
