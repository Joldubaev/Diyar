import 'package:injectable/injectable.dart';

/// Use case для расчета минимального времени подготовки заказа
@injectable
class CalculateMinimumTimeUseCase {
  /// Возвращает минимальное время (текущее время + 15 минут)
  DateTime getMinimumTime() {
    return DateTime.now().add(const Duration(minutes: 15));
  }

  /// Форматирует DateTime в строку формата HH:mm
  String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Парсит строку времени в DateTime для сегодняшнего дня
  DateTime? parseTimeString(String timeString, DateTime referenceDate) {
    final parts = timeString.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    return DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
      hour,
      minute,
    );
  }

  /// Валидирует выбранное время и возвращает валидное время
  DateTime validateSelectedTime(DateTime selectedTime, DateTime minimumTime) {
    if (selectedTime.isAfter(minimumTime) || selectedTime.isAtSameMomentAs(minimumTime)) {
      return selectedTime;
    }
    return minimumTime;
  }
}
