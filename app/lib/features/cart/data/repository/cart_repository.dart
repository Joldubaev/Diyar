import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';

import '../data.dart';

abstract class CartRepository {
  // CARTS
  Future<void> addToCart(CartItemEntity product);
  Future<void> removeFromCart(String id);
  Future<void> incrementCart(String id);
  Future<void> decrementCart(String id);
  Future<void> setCartItemCount(CartItemEntity cart);
  Future<void> clearCart();
  Stream<List<CartItemEntity>> getAllCartItems();
}

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _cartRemoteDataSource;

  CartRepositoryImpl(this._cartRemoteDataSource);

  @override
  Future<void> addToCart(CartItemEntity product) {
    return _cartRemoteDataSource.addToCart(CartItemModel.fromEntity(product));
  }

  @override
  Future<void> decrementCart(String id) {
    return _cartRemoteDataSource.decrementCart(id);
  }

  @override
  Future<void> incrementCart(String id) {
    return _cartRemoteDataSource.incrementCart(id);
  }

  @override
  Future<void> removeFromCart(String id) {
    return _cartRemoteDataSource.removeFromCart(id);
  }

  @override
  Stream<List<CartItemEntity>> getAllCartItems() {
    return _cartRemoteDataSource.getAllCartItems().map(
      (cartItemModels) => cartItemModels.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<void> clearCart() {
    return _cartRemoteDataSource.clearCart();
  }

  @override
  Future<void> setCartItemCount(CartItemEntity cart) {
    return _cartRemoteDataSource.setCartItemCount(CartItemModel.fromEntity(cart));
  }
}
