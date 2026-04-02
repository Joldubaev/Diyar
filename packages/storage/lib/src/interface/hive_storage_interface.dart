import 'dart:async';

/// Интерфейс для работы с Hive storage
/// T - тип данных, которые хранятся в box
abstract class HiveStorage<T> {
  /// Инициализация Hive и открытие box
  Future<void> init(String boxName);

  /// Сохранение значения по ключу
  Future<void> save(String key, T value);

  /// Чтение значения по ключу
  T? read(String key);

  /// Удаление значения по ключу
  Future<void> delete(String key);

  /// Проверка наличия ключа
  bool containsKey(String key);

  /// Получение всех значений
  List<T> getAll();

  /// Получение всех ключей
  List<String> getAllKeys();

  /// Очистка всех данных в box
  Future<void> clear();

  /// Получение стрима изменений в box
  Stream<List<T>> watch();

  /// Закрытие box
  Future<void> close();

  /// Проверка, открыт ли box
  bool isOpen();
}
