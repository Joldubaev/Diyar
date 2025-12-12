import 'dart:developer';
import 'package:flutter/material.dart';

/// Утилиты для работы со временем в проекте

/// Парсит строку времени формата "HH:mm" в TimeOfDay
///
/// [timeString] - строка времени в формате "HH:mm" (например, "14:30", "09:00")
///
/// Возвращает [TimeOfDay] с распарсенным временем или полночь (00:00) по умолчанию
/// в случае ошибки парсинга.
TimeOfDay parseTimeOfDay(String timeString) {
  try {
    final parts = timeString.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null && minute != null && hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
        return TimeOfDay(hour: hour, minute: minute);
      }
    }
  } catch (e) {
    log("Ошибка парсинга времени: $timeString, $e");
  }
  log("Не удалось распарсить время '$timeString', используется полночь по умолчанию.");
  return const TimeOfDay(hour: 0, minute: 0);
}

/// Преобразует TimeOfDay в количество минут с начала дня
///
/// [time] - время для преобразования
///
/// Возвращает количество минут с начала дня (0-1439)
int timeOfDayToMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}

/// Преобразует количество минут с начала дня в TimeOfDay
///
/// [minutes] - количество минут с начала дня (0-1439)
///
/// Возвращает [TimeOfDay] с соответствующим временем
TimeOfDay minutesToTimeOfDay(int minutes) {
  final totalMinutes = minutes % 1440; // Ограничиваем 24 часами
  final hour = (totalMinutes / 60).floor();
  final minute = totalMinutes % 60;
  return TimeOfDay(hour: hour, minute: minute);
}

/// Форматирует TimeOfDay в строку формата "HH:mm"
///
/// [time] - время для форматирования
///
/// Возвращает строку в формате "HH:mm" (например, "14:30", "09:05")
String formatTimeOfDay(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

/// Проверяет, находится ли текущее время в диапазоне рабочего времени
///
/// [currentTime] - текущее время для проверки
/// [startWorkTime] - время начала работы
/// [endWorkTime] - время окончания работы
///
/// Возвращает true, если магазин закрыт (время вне диапазона работы)
bool isShopClosed({
  required TimeOfDay currentTime,
  required TimeOfDay startWorkTime,
  required TimeOfDay endWorkTime,
}) {
  final currentMinutes = timeOfDayToMinutes(currentTime);
  final startMinutes = timeOfDayToMinutes(startWorkTime);
  final endMinutes = timeOfDayToMinutes(endWorkTime);

  if (startMinutes < endMinutes) {
    // Обычный случай: работа с утра до вечера (например, 10:00 - 22:00)
    return currentMinutes < startMinutes || currentMinutes >= endMinutes;
  } else {
    // Случай с переходом через полночь (например, 22:00 - 02:00)
    return currentMinutes < startMinutes && currentMinutes >= endMinutes;
  }
}
