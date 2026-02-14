import 'dart:async';
import 'package:flutter/widgets.dart';

/// Mixin для управления таймером обратного отсчета
/// T должен быть StatefulWidget, чтобы гарантировать наличие mounted
mixin TimerMixin<T extends StatefulWidget> on State<T> {
  static const int _kInitialTime = 59;

  Timer? _timer;
  int _start = _kInitialTime;
  bool isTimeEnd = false;

  int get startSeconds => _start;
  bool get timerHasEnded => isTimeEnd;

  void startTimer() {
    _timer?.cancel();
    _start = _kInitialTime;
    isTimeEnd = false;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_start <= 1) {
          setState(() {
            timer.cancel();
            isTimeEnd = true;
            _start = 0;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void initializeTimer() {
    startTimer();
  }

  void disposeTimer() {
    _timer?.cancel();
  }
}
