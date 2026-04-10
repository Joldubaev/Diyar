// ignore_for_file: avoid-dynamic

import 'dart:developer';

import 'package:rest_client/src/extended_error.dart';

/// [DataParser] - это абстрактный класс (интерфейс), который определяет
/// контракт для парсеров данных. Любой класс, реализующий этот интерфейс,
/// должен предоставить метод [parse], который преобразует динамические данные
/// (`dynamic`, обычно из JSON) в строго типизированный объект [T].
abstract class DataParser<T> {
  T parse(dynamic data);
}

/// [ListParser] - это реализация [DataParser], предназначенная для
/// парсинга JSON-массивов. Он принимает функцию-конвертер [_converter],
/// которая знает, как преобразовать один JSON-объект из списка в модель [T].
/// Опциональный параметр [forKey] позволяет извлечь список из вложенного
/// поля в JSON-ответе.
class ListParser<T> implements DataParser<List<T>> {
  ListParser(this._converter, Function(dynamic json) param1, {this.forKey});

  final T Function(Map<String, dynamic> data) _converter;
  final String? forKey;

  @override
  List<T> parse(dynamic data) {
    try {
      return forKey == null
          ? List<T>.from(
              data.map((json) => _converter(json as Map<String, dynamic>)))
          : List<T>.from(data[forKey]
              .map((json) => _converter(json as Map<String, dynamic>)));
    } catch (e, s) {
      log("$e, $s");
      throw const ParseError();
    }
  }
}

/// [ObjectParser] - это реализация [DataParser] для парсинга одного
/// JSON-объекта в модель данных [T]. Он использует предоставленную
/// функцию-конвертер [_converter] для выполнения преобразования.
class ObjectParser<T> implements DataParser<T> {
  ObjectParser(this._converter);

  final T Function(Map<String, dynamic> data) _converter;

  @override
  T parse(dynamic data) {
    try {
      return _converter(data as Map<String, dynamic>);
    } catch (e, s) {
      log("$e, $s");
      throw const ParseError();
    }
  }
}

/// [RawParser] - это реализация [DataParser] для работы с "сырыми"
/// неструктурированными данными, которые приходят в виде строки.
/// Он преобразует `dynamic` данные в [String] и передает их в функцию
/// [_converter] для дальнейшей обработки.
class RawParser<T> implements DataParser<T> {
  RawParser(this._converter);

  final T Function(String data) _converter;

  @override
  T parse(dynamic data) {
    try {
      return _converter(data as String);
    } catch (e, s) {
      log("$e, $s");
      throw const ParseError();
    }
  }
}
