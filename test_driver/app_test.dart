import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/helpers.dart';

void main() async {
  late FlutterDriver driver;

  group('Diyar App Integration Test', () {
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });
  });

  group('auth', () {});

  tearDownAll(() async {
    await addDelay(300);
    await driver.close();
  });
}
