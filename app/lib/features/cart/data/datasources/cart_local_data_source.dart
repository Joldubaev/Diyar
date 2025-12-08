import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:injectable/injectable.dart';
import 'package:storage/storage.dart';

abstract class CartLocalDataSource {
  Future<void> init(); // Method to initialize Hive box
  Future<void> saveCartItem(CartItemModel item);
  Future<void> removeCartItem(String foodId);
  Future<void> updateCartItemQuantity(String foodId, int newQuantity);
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
    if (item.food?.id == null) return; // Need foodId as key
    await _hiveStorage.save(item.food!.id!, item);
  }

  @override
  Future<void> removeCartItem(String foodId) async {
    await _hiveStorage.delete(foodId);
  }

  @override
  Future<void> updateCartItemQuantity(String foodId, int newQuantity) async {
    final existingItem = _hiveStorage.read(foodId);
    if (existingItem != null) {
      final updatedItem = CartItemModel(
        food: existingItem.food,
        quantity: newQuantity, // Update quantity
        totalPrice: existingItem.totalPrice, // Keep other fields
      );
      await _hiveStorage.save(foodId, updatedItem);
    }
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
