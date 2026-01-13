/// Repository для операций безопасности (PIN-код)
abstract class SecurityRepository {
  /// Установить PIN-код
  Future<void> setPinCode(String code);

  /// Получить PIN-код
  Future<String?> getPinCode();
}

