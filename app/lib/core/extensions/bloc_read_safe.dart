import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Расширение для безопасного чтения Bloc/Cubit из контекста
extension BlocReadSafe on BuildContext {
  /// Безопасно читает Bloc/Cubit из контекста
  /// Возвращает null, если провайдер не найден, вместо выбрасывания исключения
  T? maybeRead<T extends StateStreamableSource<Object?>>() {
    try {
      return read<T>();
    } catch (e) { log('[bloc_read_safe] $e');
      return null;
    }
  }
}
