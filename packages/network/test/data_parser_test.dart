import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() {
  group('ListParser', () {
    test('parses list of maps', () {
      final parser = ListParser<String>(
        (json) => json['name'] as String,
      );
      final data = [
        {'name': 'Pizza'},
        {'name': 'Burger'},
      ];
      final result = parser.parse(data);
      expect(result, ['Pizza', 'Burger']);
    });

    test('parses list from nested key', () {
      final parser = ListParser<int>(
        (json) => json['id'] as int,
        forKey: 'items',
      );
      final data = {
        'items': [
          {'id': 1},
          {'id': 2},
        ]
      };
      final result = parser.parse(data);
      expect(result, [1, 2]);
    });

    test('throws ParseError on invalid data', () {
      final parser = ListParser<String>((json) => json['name'] as String);
      expect(
        () => parser.parse('not a list'),
        throwsA(isA<ParseError>()),
      );
    });
  });

  group('ObjectParser', () {
    test('parses single object', () {
      final parser = ObjectParser<String>((json) => json['name'] as String);
      final result = parser.parse({'name': 'Diyar'});
      expect(result, 'Diyar');
    });

    test('throws ParseError on invalid data', () {
      final parser = ObjectParser<String>((json) => json['name'] as String);
      expect(
        () => parser.parse('not a map'),
        throwsA(isA<ParseError>()),
      );
    });
  });

  group('RawParser', () {
    test('parses raw string', () {
      final parser = RawParser<int>((data) => int.parse(data));
      expect(parser.parse('42'), 42);
    });

    test('throws ParseError on invalid data', () {
      final parser = RawParser<int>((data) => int.parse(data));
      expect(
        () => parser.parse(123),
        throwsA(isA<ParseError>()),
      );
    });
  });
}
