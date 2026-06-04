import '../models/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getRemoteCart(String userId);
  Future<void> addToRemoteCart(String userId, String productId, int quantity);
  Future<void> updateRemoteCartQuantity(String userId, String productId, int quantity);
  Future<void> removeFromRemoteCart(String userId, String productId);
  Future<void> clearRemoteCart(String userId);
}
