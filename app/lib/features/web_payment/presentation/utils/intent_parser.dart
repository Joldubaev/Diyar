import 'dart:developer' as developer;

import 'package:url_launcher/url_launcher.dart';

// ignore_for_file: deprecated_member_use
// RegExp нужен для replaceFirst при парсинге intent fragment

/// Парсит intent:// URL и открывает банковское приложение или fallback.
class IntentParser {
  /// Парсит intent:// URL и возвращает true, если запуск выполнен
  /// Обрабатывает: package, S.browser_fallback_url, экранирование
  static Future<bool> handleIntentUrl(String intentUrl) async {
    try {
      if (!intentUrl.startsWith('intent://')) return false;

      final parsedUri = Uri.parse(intentUrl.replaceFirst('intent://', 'https://'));
      final fragment = parsedUri.fragment;

      final params = _parseIntentFragment(fragment);

      // Логируем технические данные, чтобы собрать список поддержанных банков
      final packageName = params['package'];
      if (packageName != null && packageName.isNotEmpty) {
        developer.log('[WebPayment][Intent] detected package: $packageName');
      }

      final fallbackUrlRaw = params['S.browser_fallback_url'];
      final fallbackUrl = fallbackUrlRaw != null
          ? Uri.tryParse(
              Uri.decodeComponent(fallbackUrlRaw.split(',').first.trim()),
            )
          : null;
      if (fallbackUrl != null) {
        developer.log('[WebPayment][Intent] fallback host: ${fallbackUrl.host}');
      }

      final scheme = params['scheme'] ?? 'https';
      developer.log('[WebPayment][Intent] scheme: $scheme');

      final deepLink = Uri(
        scheme: scheme,
        host: parsedUri.host,
        path: parsedUri.path,
        queryParameters: parsedUri.queryParameters.isNotEmpty ? parsedUri.queryParameters : null,
      );

      // Пробуем открыть deep link (не полагаемся на canLaunchUrl —
      // package visibility может давать false даже при установленном приложении)
      try {
        final launched = await launchUrl(
          deepLink,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return true;
      } catch (e) {
        developer.log('[WebPayment] Deep link launch failed: $e');
      }

      if (fallbackUrl != null) {
        try {
          return await launchUrl(
            fallbackUrl,
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          developer.log('[WebPayment] Fallback launch failed: $e');
        }
      }

      try {
        return await launchUrl(
          Uri.parse(intentUrl.replaceFirst('intent://', 'https://')),
          mode: LaunchMode.platformDefault,
        );
      } catch (e) {
        developer.log('[WebPayment] Https fallback failed: $e');
        return false;
      }
    } catch (e) {
      developer.log('[WebPayment] Intent parse error: $e');
      return false;
    }
  }

  static Map<String, String> _parseIntentFragment(String fragment) {
    final params = <String, String>{};
    final clean = fragment.replaceFirst(RegExp(r'^#?Intent;?'), '').replaceFirst(RegExp(r';end$'), '');

    for (final part in clean.split(';')) {
      if (part.contains('=')) {
        final kv = part.split('=');
        if (kv.length >= 2) {
          params[kv[0]] = kv.sublist(1).join('=');
        }
      } else if (part.isNotEmpty) {
        params[part] = 'true';
      }
    }
    return params;
  }
}
