import 'dart:io';

import 'package:diyar/config/config.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:diyar/main.dart' as app;

Future<void> main() async {
  enableFlutterDriverExtension(
    handler: (command) async {
      var result = '';
      switch (command) {
        case 'getPlatformCommand':
          result = Platform.operatingSystem;
      }
      return Future.value(result);
    },
  );

  await app.main(appConfig: const AppConfig(isIntegrationTest: true));
}
