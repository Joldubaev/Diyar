import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Расширение для безопасного чтения Bloc/Cubit из контекста.
///
/// [ProviderNotFoundException] — ожидаемая ситуация (виджет отрендерен вне
/// поддерева с нужным провайдером), её глотаем молча.
/// Любые другие ошибки логируем — это реальные баги.
extension BlocReadSafe on BuildContext {
  T? maybeRead<T extends StateStreamableSource<Object?>>() {
    try {
      return read<T>();
    } on ProviderNotFoundException {
      return null;
    } catch (e, st) {
      log('[bloc_read_safe] $e', error: e, stackTrace: st);
      return null;
    }
  }
}
