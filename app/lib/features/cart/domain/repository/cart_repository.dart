import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<void> init();
  Future<void> addToCart(CartItemEntity product);
  Future<void> removeFromCart(String foodId);
  Future<void> incrementCart(String foodId);
  Future<void> decrementCart(String foodId);
  Future<void> setCartItemCount(CartItemEntity cart);
  Future<void> clearCart();
  Stream<List<CartItemEntity>> getAllCartItems(); // Returns stream of Entities
}
