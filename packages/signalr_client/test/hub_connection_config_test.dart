import 'package:flutter_test/flutter_test.dart';
import 'package:signalr_client/signalr_client.dart';

void main() {
  group('HubConnectionConfig', () {
    test('effectiveUrl returns hubUrl when no accessToken', () {
      const config = HubConnectionConfig(hubUrl: 'https://api.diyar.kg/hub');
      expect(config.effectiveUrl, 'https://api.diyar.kg/hub');
    });

    test('effectiveUrl appends access_token when provided', () {
      const config = HubConnectionConfig(
        hubUrl: 'https://api.diyar.kg/hub',
        accessToken: 'my-jwt-token',
      );
      expect(
        config.effectiveUrl,
        'https://api.diyar.kg/hub?access_token=my-jwt-token',
      );
    });

    test('effectiveUrl encodes special characters in token', () {
      const config = HubConnectionConfig(
        hubUrl: 'https://api.diyar.kg/hub',
        accessToken: 'token with spaces&special=chars',
      );
      expect(
        config.effectiveUrl,
        contains('access_token=token%20with%20spaces%26special%3Dchars'),
      );
    });

    test('effectiveUrl returns hubUrl for empty accessToken', () {
      const config = HubConnectionConfig(
        hubUrl: 'https://api.diyar.kg/hub',
        accessToken: '',
      );
      expect(config.effectiveUrl, 'https://api.diyar.kg/hub');
    });

    test('defaults are correct', () {
      const config = HubConnectionConfig(hubUrl: 'https://example.com');
      expect(config.autoReconnect, isTrue);
      expect(config.loggerName, 'SignalR');
      expect(config.accessToken, isNull);
    });
  });
}
