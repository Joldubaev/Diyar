import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

Logger logger = Logger('APP_LOGGER');

void initRootLogger() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.OFF;
  }

  hierarchicalLoggingEnabled = true;

  Logger.root.onRecord.listen((record) {
    if (!kDebugMode) return;

    const end = '\x1b[0m';
    String color;

    switch (record.level.name) {
      case 'INFO':
        color = '\x1b[94m'; // blue
        break;
      case 'WARNING':
        color = '\x1b[93m'; // yellow
        break;
      case 'SEVERE':
        color = '\x1b[31m'; // red
        break;
      case 'SHOUT':
        color = '\x1b[41m\x1b[93m'; // yellow on red
        break;
      default:
        color = '\x1b[37m'; // white
    }

    final message = '$color${record.message}$end';
    developer.log(message, name: record.loggerName, level: record.level.value);
  });
}
