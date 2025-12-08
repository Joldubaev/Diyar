import 'dart:async';
import 'package:flutter/widgets.dart';

/// Mixin для управления таймером обратного отсчета
/// T должен быть StatefulWidget, чтобы гарантировать наличие mounted
mixin TimerMixin<T extends StatefulWidget> on State<T> {
  // Константы таймера
  static const int _kInitialTime = 59;

  Timer? _timer;
  int _start = _kInitialTime;
  bool isTimeEnd = false;

  // Геттеры для доступа из внешнего виджета
  int get startSeconds => _start;
  bool get timerHasEnded => isTimeEnd;

  /// Запускает или перезапускает таймер обратного отсчета.
  void startTimer() {
    _timer?.cancel(); // Гарантируем отмену предыдущего
    _start = _kInitialTime; // Сброс
    isTimeEnd = false;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        // Проверяем mounted, чтобы избежать ошибок после dispose
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_start <= 1) {
          setState(() {
            timer.cancel();
            isTimeEnd = true;
            _start = 0; // Для отображения "0 сек" если нужно
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  /// Метод, который нужно вызвать в initState
  void initializeTimer() {
    startTimer();
  }

  /// Метод, который нужно вызвать в dispose
  void disposeTimer() {
    _timer?.cancel();
  }
}
