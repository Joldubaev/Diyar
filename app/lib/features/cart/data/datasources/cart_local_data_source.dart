import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:injectable/injectable.dart';
import 'package:storage/storage.dart';

/// Позиции корзины хранятся по ключу [CartItemModelX.rowKey]
/// (`foodId` или `foodId::garnishId`) — одно блюдо с разными гарнирами
/// образует независимые позиции.
abstract class CartLocalDataSource {
  Future<void> init(); // Method to initialize Hive box
  Future<void> saveCartItem(CartItemModel item);
  Future<void> removeCartItem(String rowKey);
  Future<void> updateCartItemQuantity(String rowKey, int newQuantity);
  Future<void> incrementCartItem(String rowKey);
  Future<void> decrementCartItem(String rowKey);
  Future<void> addOrUpdateCartItem(CartItemModel item);
  CartItemModel? getCartItem(String rowKey);
  List<CartItemModel> getAllCartItems(); // Get current items synchronously
  Stream<List<CartItemModel>> getCartItemsStream(); // Stream for reactive updates
  Future<void> clearCart();
  Future<void> close(); // Method to close Hive box
}

@LazySingleton(as: CartLocalDataSource)
class CartHiveDataSource implements CartLocalDataSource {
  static const String _boxName = 'cartBox';
  late final HiveStorage<CartItemModel> _hiveStorage;

  CartHiveDataSource() {
    _hiveStorage = HiveStorageImpl<CartItemModel>();
  }

  @override
  Future<void> init() async {
    // Ensure adapters are registered (should be done in main.dart ideally)
    // Hive.registerAdapter(CartItemModelAdapter());
    // Hive.registerAdapter(FoodModelAdapter());
    await _hiveStorage.init(_boxName);
  }

  @override
  Future<void> saveCartItem(CartItemModel item) async {
    final key = item.rowKey;
    if (key == null) return; // Need foodId as key
    await _hiveStorage.save(key, item);
  }

  @override
  Future<void> removeCartItem(String rowKey) async {
    await _hiveStorage.delete(rowKey);
  }

  @override
  Future<void> updateCartItemQuantity(String rowKey, int newQuantity) async {
    final existingItem = _hiveStorage.read(rowKey);
    if (existingItem != null) {
      final updatedItem = existingItem.copyWith(quantity: newQuantity);
      await _hiveStorage.save(rowKey, updatedItem);
    }
  }

  @override
  Future<void> incrementCartItem(String rowKey) async {
    final existingItem = _hiveStorage.read(rowKey);
    if (existingItem != null) {
      final newQuantity = (existingItem.quantity ?? 0) + 1;
      await updateCartItemQuantity(rowKey, newQuantity);
    }
  }

  @override
  Future<void> decrementCartItem(String rowKey) async {
    final existingItem = _hiveStorage.read(rowKey);
    if (existingItem != null) {
      final newQuantity = (existingItem.quantity ?? 1) - 1;
      if (newQuantity <= 0) {
        await removeCartItem(rowKey);
      } else {
        await updateCartItemQuantity(rowKey, newQuantity);
      }
    }
  }

  @override
  Future<void> addOrUpdateCartItem(CartItemModel item) async {
    final key = item.rowKey;
    if (key == null) return;

    final existingItem = _hiveStorage.read(key);

    if (existingItem != null) {
      // Item exists, update quantity by adding new quantity
      final newQuantity = (existingItem.quantity ?? 0) + (item.quantity ?? 1);
      await updateCartItemQuantity(key, newQuantity);
    } else {
      // Item doesn't exist, save new
      await saveCartItem(item);
    }
  }

  @override
  CartItemModel? getCartItem(String rowKey) {
    return _hiveStorage.read(rowKey);
  }

  @override
  List<CartItemModel> getAllCartItems() {
    return _hiveStorage.getAll();
  }

  @override
  Stream<List<CartItemModel>> getCartItemsStream() {
    return _hiveStorage.watch();
  }

  @override
  Future<void> clearCart() async {
    await _hiveStorage.clear();
  }

  @override
  Future<void> close() async {
    await _hiveStorage.close();
  }
}
