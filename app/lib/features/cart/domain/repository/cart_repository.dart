import 'package:diyar/features/cart/domain/domain.dart';

/// Позиции корзины идентифицируются по [CartItemEntity.rowKey]
/// (`foodId` или `foodId::garnishId` для блюд с гарниром).
abstract class CartRepository {
  Future<void> init();
  Future<void> addToCart(CartItemEntity product);
  Future<void> removeFromCart(String rowKey);
  Future<void> incrementCart(String rowKey);
  Future<void> decrementCart(String rowKey);
  Future<void> setCartItemCount(CartItemEntity cart);
  Future<void> clearCart();
  Stream<List<CartItemEntity>> getAllCartItems();
  List<CartItemEntity> getCurrentCartItems();
}
