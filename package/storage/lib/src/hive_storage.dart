import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:storage/src/interface/hive_storage_interface.dart';

/// Реализация Hive storage
class HiveStorageImpl<T> implements HiveStorage<T> {
  Box<T>? _box;
  String? _boxName;
  StreamController<List<T>>? _streamController;
  void Function()? _listener;

  @override
  Future<void> init(String boxName) async {
    if (_box != null && _box!.isOpen) {
      return; // Box уже открыт
    }

    _boxName = boxName;
    _box = await Hive.openBox<T>(boxName);
    _initStream();
  }

  void _initStream() {
    _streamController = StreamController<List<T>>.broadcast();
    _emitCurrentValues();

    // Слушаем изменения в box
    _listener = _emitCurrentValues;
    _box?.listenable().addListener(_listener!);
  }

  void _emitCurrentValues() {
    if (_streamController != null && !_streamController!.isClosed) {
      _streamController!.add(getAll());
    }
  }

  Box<T> _getBox() {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Hive box "$_boxName" is not open. Call init() first.');
    }
    return _box!;
  }

  @override
  Future<void> save(String key, T value) async {
    await _getBox().put(key, value);
  }

  @override
  T? read(String key) {
    return _getBox().get(key);
  }

  @override
  Future<void> delete(String key) async {
    await _getBox().delete(key);
  }

  @override
  bool containsKey(String key) {
    return _getBox().containsKey(key);
  }

  @override
  List<T> getAll() {
    return _getBox().values.toList();
  }

  @override
  List<String> getAllKeys() {
    return _getBox().keys.cast<String>().toList();
  }

  @override
  Future<void> clear() async {
    await _getBox().clear();
  }

  @override
  Stream<List<T>> watch() {
    if (_streamController == null) {
      throw Exception('Hive box is not initialized. Call init() first.');
    }
    return _streamController!.stream;
  }

  @override
  Future<void> close() async {
    if (_listener != null && _box != null) {
      _box!.listenable().removeListener(_listener!);
    }
    await _streamController?.close();
    await _box?.close();
    _box = null;
    _boxName = null;
    _streamController = null;
    _listener = null;
  }

  @override
  bool isOpen() {
    return _box != null && _box!.isOpen;
  }
}
