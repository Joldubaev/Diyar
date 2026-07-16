import 'dart:developer';
extension OrderDateTimeParserX on String? {
  /// Парсит дату из форматов: dd.MM.yyyy, MM/dd/yyyy, yyyy-MM-dd (с необязательным временем HH:mm:ss).
  DateTime? parseOrderDateTime() {
    if (this == null || this!.trim().isEmpty) return null;

    try {
      final trimmed = this!.trim();
      final parts = trimmed.split(' ');
      final datePart = parts[0];

      DateTime? date;

      if (datePart.contains('.')) {
        final d = datePart.split('.');
        if (d.length == 3) date = DateTime(int.parse(d[2]), int.parse(d[1]), int.parse(d[0]));
      } else if (datePart.contains('/')) {
        final d = datePart.split('/');
        if (d.length == 3) date = DateTime(int.parse(d[2]), int.parse(d[0]), int.parse(d[1]));
      } else if (datePart.contains('-')) {
        final d = datePart.split('-');
        if (d.length == 3) date = DateTime(int.parse(d[0]), int.parse(d[1]), int.parse(d[2]));
      }

      if (date == null) return null;

      if (parts.length > 1) {
        final t = parts[1].split(':');
        date = DateTime(
          date.year,
          date.month,
          date.day,
          t.isNotEmpty ? int.parse(t[0]) : 0,
          t.length >= 2 ? int.parse(t[1]) : 0,
          t.length >= 3 ? int.parse(t[2]) : 0,
        );
      }

      return date;
    } catch (e) { log('[date_time_parser] $e');
      return null;
    }
  }
}
