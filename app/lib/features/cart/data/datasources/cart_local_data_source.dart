import 'dart:async';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import hive_flutter

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

class CartHiveDataSource implements CartLocalDataSource {
  static const String _boxName = 'cartBox';
  Box<CartItemModel>? _box;

  final StreamController<List<CartItemModel>> _cartStreamController = StreamController.broadcast();

  @override
  Future<void> init() async {
    // Ensure adapters are registered (should be done in main.dart ideally)
    // Hive.registerAdapter(CartItemModelAdapter());
    // Hive.registerAdapter(FoodModelAdapter());
    _box = await Hive.openBox<CartItemModel>(_boxName);
    _emitCurrentCart(); // Emit initial cart state
    _box?.listenable().addListener(_emitCurrentCart); // Listen for changes
  }

  Box<CartItemModel> _getBox() {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Cart Hive box is not open. Call init() first.');
    }
    return _box!;
  }

  void _emitCurrentCart() {
    if (!_cartStreamController.isClosed) {
      _cartStreamController.add(getAllCartItems());
    }
  }

  @override
  Future<void> saveCartItem(CartItemModel item) async {
    if (item.food?.id == null) return; // Need foodId as key
    await _getBox().put(item.food!.id!, item);
    // Change listener will call _emitCurrentCart
  }

  @override
  Future<void> removeCartItem(String foodId) async {
    await _getBox().delete(foodId);
    // Change listener will call _emitCurrentCart
  }

  @override
  Future<void> updateCartItemQuantity(String foodId, int newQuantity) async {
    final box = _getBox();
    final existingItem = box.get(foodId);
    if (existingItem != null) {
      final updatedItem = CartItemModel(
        food: existingItem.food,
        quantity: newQuantity, // Update quantity
        totalPrice: existingItem.totalPrice, // Keep other fields
      );
      await box.put(foodId, updatedItem);
      // Change listener will call _emitCurrentCart
    }
  }

  @override
  List<CartItemModel> getAllCartItems() {
    return _getBox().values.toList();
  }

  @override
  Stream<List<CartItemModel>> getCartItemsStream() {
    // Return the stream from the controller
    // Removed immediate emit with Future.delayed
    // Initial state is emitted in init() after box is open, and listener handles updates
    return _cartStreamController.stream;
  }

  @override
  Future<void> clearCart() async {
    await _getBox().clear();
    // Change listener will call _emitCurrentCart
  }

  @override
  Future<void> close() async {
    _box?.listenable().removeListener(_emitCurrentCart);
    await _cartStreamController.close();
    await _getBox().close();
  }
}
