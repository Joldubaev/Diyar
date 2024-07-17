import 'dart:convert';
import 'dart:developer';
import 'package:xml/xml.dart' as xml;
import 'package:dio/dio.dart';

abstract class SmsRemoteDataSource {
  Future<void> sendSms(String code, String phone);
}

class SmsRemoteDataSourceImpl implements SmsRemoteDataSource {
  final Dio dio;

  SmsRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> sendSms(String code, String phone) async {
    final builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('message', nest: () {
      builder.element('login', nest: 'diyar');
      builder.element('pwd', nest: 'EvofRJoN');
      builder.element('id', nest: code);
      builder.element('sender', nest: 'DiyarKG');
      builder.element('text', nest: "Ваш код подтверждения - $code");
      builder.element('phones', nest: () {
        builder.element('phone', nest: phone);
      });
    });

    final xmlData = builder.buildDocument().toXmlString();
    log(xmlData);

    final utf8Data = utf8.encode(xmlData);
    final contentLength = utf8Data.length.toString();

    try {
      final response = await dio.post(
        'https://smspro.nikita.kg/api/message',
        options: Options(
          headers: {
            'Content-Type': 'application/xml',
            'Content-Length': contentLength,
          },
        ),
        data: utf8Data,
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка: $e');
      throw Exception('Ошибка при отправке SMS: $e');
    }
  }
}
