import 'dart:developer';

import 'package:network/src/error/extended_error.dart';

/// Contract for parsing raw response data into typed objects.
abstract class DataParser<T> {
  T parse(dynamic data);
}

/// Parses a JSON array into `List<T>`.
/// Optionally extracts the list from a nested [forKey] field.
class ListParser<T> implements DataParser<List<T>> {
  ListParser(this._converter, {this.forKey});

  final T Function(Map<String, dynamic> data) _converter;
  final String? forKey;

  @override
  List<T> parse(dynamic data) {
    try {
      final list = forKey == null ? data : data[forKey];
      return List<T>.from(
        (list as List).map(
          (json) => _converter(json as Map<String, dynamic>),
        ),
      );
    } catch (e, s) {
      log('ListParser error: $e, $s');
      throw const ParseError();
    }
  }
}

/// Parses a single JSON object into `T`.
class ObjectParser<T> implements DataParser<T> {
  ObjectParser(this._converter);

  final T Function(Map<String, dynamic> data) _converter;

  @override
  T parse(dynamic data) {
    try {
      return _converter(data as Map<String, dynamic>);
    } catch (e, s) {
      log('ObjectParser error: $e, $s');
      throw const ParseError();
    }
  }
}

/// Parses raw string data into `T`.
class RawParser<T> implements DataParser<T> {
  RawParser(this._converter);

  final T Function(String data) _converter;

  @override
  T parse(dynamic data) {
    try {
      return _converter(data as String);
    } catch (e, s) {
      log('RawParser error: $e, $s');
      throw const ParseError();
    }
  }
}
