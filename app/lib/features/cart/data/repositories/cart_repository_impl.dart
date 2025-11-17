import 'dart:async'; // For StreamController and map
import 'dart:developer';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/features/cart/domain/domain.dart';
import 'package:diyar/features/cart/data/datasources/cart_local_data_source.dart';

// Assuming CartItemModel has these methods/constructors:
// CartItemModel.fromEntity(CartItemEntity entity);
// CartItemEntity toEntity();

// const _boxName = 'cartBox'; // Defined locally, consider moving to DataSource

// Не используем @LazySingleton здесь, так как регистрация идет через CartModule
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;
  // Potentially add mappers here if needed

  CartRepositoryImpl(this._localDataSource);

  @override
  Future<void> init() async {
    await _localDataSource.init(); // Call datasource init
  }

  @override
  Future<void> addToCart(CartItemEntity product) async {
    // Check if item already exists to update quantity or save new
    final existingItems = _localDataSource.getAllCartItems(); // Sync fetch is fine here
    final existingItemIndex = existingItems.indexWhere((item) => item.food?.id == product.food?.id);

    if (existingItemIndex != -1) {
      // Item exists, update quantity
      final existingItem = existingItems[existingItemIndex];
      final newQuantity = (existingItem.quantity ?? 0) + (product.quantity ?? 1);
      // Ensure product.food and product.food.id are not null
      if (product.food?.id != null) {
        await _localDataSource.updateCartItemQuantity(product.food!.id!, newQuantity);
      } else {
        // Handle error: product must have a food item with an ID
        log("Error: Cannot add product to cart without a valid food ID.");
      }
    } else {
      // Item doesn't exist, add new
      // We need a proper CartItemModel.fromEntity implementation
      final cartModel = CartItemModel.fromEntity(product); // Needs implementation in CartItemModel
      if (cartModel.food?.id != null) {
        await _localDataSource.saveCartItem(cartModel);
      } else {
        // Handle error: product must have a food item with an ID
        log("Error: Cannot save product to cart without a valid food ID.");
      }
    }
  }

  @override
  Future<void> clearCart() async {
    await _localDataSource.clearCart();
  }

  @override
  Future<void> decrementCart(String foodId) async {
    final existingItems = _localDataSource.getAllCartItems();
    try {
      final existingItem = existingItems.firstWhere((item) => item.food?.id == foodId);

      final newQuantity = (existingItem.quantity ?? 1) - 1;

      if (newQuantity <= 0) {
        await _localDataSource.removeCartItem(foodId);
      } else {
        await _localDataSource.updateCartItemQuantity(foodId, newQuantity);
      }
    } catch (e) {
      // Handle case where item is not found
      log("Error decrementing cart: Item with foodId $foodId not found. $e");
      // Optionally rethrow or handle differently
    }
  }

  @override
  Stream<List<CartItemEntity>> getAllCartItems() {
    // Map the stream of Models to a stream of Entities
    return _localDataSource.getCartItemsStream().map((listModels) =>
            listModels.map((model) => model.toEntity()).toList() // Needs toEntity implementation in CartItemModel
        );
  }

  @override
  Future<void> incrementCart(String foodId) async {
    final existingItems = _localDataSource.getAllCartItems();
    try {
      final existingItem = existingItems.firstWhere((item) => item.food?.id == foodId);

      final newQuantity = (existingItem.quantity ?? 0) + 1;
      await _localDataSource.updateCartItemQuantity(foodId, newQuantity);
    } catch (e) {
      // Handle case where item is not found
      log("Error incrementing cart: Item with foodId $foodId not found. $e");
      // Optionally rethrow or handle differently
    }
  }

  @override
  Future<void> removeFromCart(String foodId) async {
    await _localDataSource.removeCartItem(foodId);
  }

  // Реализация синхронного получения текущих элементов
  @override
  List<CartItemEntity> getCurrentCartItems() {
    try {
      final models = _localDataSource.getAllCartItems();
      // Преобразуем модели из dataSource в entities
      // Убедитесь, что у CartItemModel есть метод toEntity()
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      log("Error getting current cart items: $e");
      return []; // Возвращаем пустой список при ошибке
    }
  }

  // setCartItemCount uses localDataSource now
  @override
  Future<void> setCartItemCount(CartItemEntity cart) async {
    if (cart.food?.id == null || cart.quantity == null) {
      log("Error setting cart item count: Food ID or quantity is null.");
      return; // Guard clause
    }

    final foodId = cart.food!.id!;
    final quantity = cart.quantity!;

    if (quantity <= 0) {
      await _localDataSource.removeCartItem(foodId);
    } else {
      // Check if item exists to decide between save and update
      final existingItems = _localDataSource.getAllCartItems();
      final existingItemIndex = existingItems.indexWhere((item) => item.food?.id == foodId);

      if (existingItemIndex != -1) {
        await _localDataSource.updateCartItemQuantity(foodId, quantity);
      } else {
        // If setting count for a non-existent item, treat as add
        final cartModel = CartItemModel.fromEntity(cart); // Needs implementation in CartItemModel
        await _localDataSource.saveCartItem(cartModel);
      }
    }
  }
}
