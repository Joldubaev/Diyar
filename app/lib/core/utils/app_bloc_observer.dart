import 'package:flutter_bloc/flutter_bloc.dart';

/// Глобальный BLoC-логгер с цветным выводом
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver({this.onLog});

  final void Function(String log, {required String name})? onLog;

  final String divider = '────────────────────────────────────────';

  void _logBlock({
    required String title,
    required List<String> body,
    required String color,
  }) {
    const end = '\x1b[0m';

    final buffer = StringBuffer();
    buffer.writeln('$color$divider$end');
    buffer.writeln('$color$title$end');
    buffer.writeln('$color$divider$end');

    for (final l in body) {
      if (l.trim().isNotEmpty) buffer.writeln(l);
    }

    buffer.writeln('$color$divider$end');

    onLog?.call(buffer.toString(), name: 'BLOC');
  }

  String _pretty(dynamic v) => v.toString().replaceAll('\n', '\n   ');

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    _logBlock(
      title: 'BLoC CREATED (${bloc.runtimeType})',
      color: '\x1b[36m', // cyan
      body: ['• Initial State:', '   ${_pretty(bloc.state)}'],
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Временно для теста: логируем только Loading/Error, чтобы не засорять консоль
    final nextStr = change.nextState.toString();
    if (nextStr.contains('Loading') || nextStr.contains('Error')) {
      onLog?.call('CHANGE: ${bloc.runtimeType} | $nextStr', name: 'BLOC');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _logBlock(
      title: 'BLoC ERROR (${bloc.runtimeType})',
      color: '\x1b[31m', // red
      body: [
        '• Error:',
        '   $error',
        '• Stack Trace:',
        '   ${_pretty(stackTrace)}',
      ],
    );

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    _logBlock(
      title: 'BLoC CLOSED (${bloc.runtimeType})',
      color: '\x1b[90m', // grey
      body: ['• Final State:', '   ${_pretty(bloc.state)}'],
    );

    super.onClose(bloc);
  }
}
