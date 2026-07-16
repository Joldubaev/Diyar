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
    if (product.food?.id == null) {
      log("Error: Cannot add product to cart without a valid food ID.");
      return;
    }

    // Преобразуем entity в model и используем метод datasource
    final cartModel = CartItemModel.fromEntity(product);
    await _localDataSource.addOrUpdateCartItem(cartModel);
  }

  @override
  Future<void> clearCart() async {
    await _localDataSource.clearCart();
  }

  @override
  Future<void> decrementCart(String rowKey) async {
    // Логика уменьшения количества теперь в datasource
    await _localDataSource.decrementCartItem(rowKey);
  }

  @override
  Stream<List<CartItemEntity>> getAllCartItems() {
    // Map the stream of Models to a stream of Entities
    return _localDataSource.getCartItemsStream().map((listModels) =>
            listModels.map((model) => model.toEntity()).toList() // Needs toEntity implementation in CartItemModel
        );
  }

  @override
  Future<void> incrementCart(String rowKey) async {
    // Логика увеличения количества теперь в datasource
    await _localDataSource.incrementCartItem(rowKey);
  }

  @override
  Future<void> removeFromCart(String rowKey) async {
    await _localDataSource.removeCartItem(rowKey);
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

  @override
  Future<void> setCartItemCount(CartItemEntity cart) async {
    final rowKey = cart.rowKey;
    if (rowKey == null || cart.quantity == null) {
      log("Error setting cart item count: Food ID or quantity is null.");
      return;
    }

    final quantity = cart.quantity!;

    if (quantity <= 0) {
      await _localDataSource.removeCartItem(rowKey);
    } else {
      // Используем метод datasource для проверки существования
      final existingItem = _localDataSource.getCartItem(rowKey);

      if (existingItem != null) {
        await _localDataSource.updateCartItemQuantity(rowKey, quantity);
      } else {
        // Если элемент не существует, добавляем новый
        final cartModel = CartItemModel.fromEntity(cart);
        await _localDataSource.saveCartItem(cartModel);
      }
    }
  }
}
