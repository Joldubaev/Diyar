import 'dart:developer';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

/// Сервис для открытия карт (2GIS, Yandex Maps и т.д.)
@injectable
class MapService {
  /// Открывает 2GIS с поиском по адресу
  Future<void> open2GIS(BuildContext context, String address) async {
    try {
      final trimmedAddress = address.trim();
      if (trimmedAddress.isEmpty) {
        if (!context.mounted) return;
        SnackBarMessage().showErrorSnackBar(
          message: 'Адрес не указан',
          context: context,
        );
        return;
      }

      // Формируем URL для 2GIS
      final url = 'https://2gis.kg/kyrgyzstan/search/${Uri.encodeComponent(trimmedAddress)}';
      final uri = Uri.parse(url);

      log('MapService: Attempting to open 2GIS with address: $trimmedAddress');
      log('MapService: URL: $url');

      // Пробуем открыть напрямую без проверки canLaunchUrl
      // так как проверка может быть неточной на некоторых устройствах
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        log('MapService: Successfully launched 2GIS');
      } catch (e) {
        // Если externalApplication не сработал, пробуем platformDefault
        log('MapService: externalApplication failed, trying platformDefault: $e');
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.platformDefault,
          );
          log('MapService: Successfully launched 2GIS with platformDefault');
        } catch (e2) {
          if (!context.mounted) return;
          SnackBarMessage().showErrorSnackBar(
            message: 'Не удалось открыть карту. Установите приложение 2GIS.',
            context: context,
          );
          log('MapService: Failed to open 2GIS: $e2');
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      SnackBarMessage().showErrorSnackBar(
        message: 'Ошибка при открытии карты',
        context: context,
      );
      log('MapService: Error opening map: $e');
    }
  }
}
