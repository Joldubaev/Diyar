/// Утилиты для обработки ошибок API
class ApiErrorUtils {
  /// Проверяет, является ли сообщение ошибкой "не найдено"
  /// Используется для определения, нужно ли обрабатывать 404 как пустой список
  static bool isNotFoundMessage(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('не найдены') ||
        lowerMessage.contains('не найден') ||
        lowerMessage.contains('not found') ||
        lowerMessage.contains('нет шаблонов') ||
        lowerMessage.contains('шаблон');
  }
}
