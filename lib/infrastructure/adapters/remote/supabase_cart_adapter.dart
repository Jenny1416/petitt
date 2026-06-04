import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/cart_item.dart';
import '../../../domain/models/product.dart';
import '../../../domain/ports/cart_repository.dart';

class SupabaseCartAdapter implements CartRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<CartItem>> getRemoteCart(String userId) async {
    try {
      final response = await _client
          .from('cart_items')
          .select('*, products(*)')
          .eq('user_id', userId);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((item) {
        final product = Product.fromJson(item['products']);
        return CartItem(product, quantity: item['quantity']);
      }).toList();
    } catch (e) {
      print('Error al obtener carrito de Supabase: $e');
      return [];
    }
  }

  @override
  Future<void> addToRemoteCart(String userId, String productId, int quantity) async {
    try {
      await _client.from('cart_items').upsert({
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      }, onConflict: 'user_id, product_id');
    } catch (e) {
      print('Error al añadir al carrito en Supabase: $e');
    }
  }

  @override
  Future<void> updateRemoteCartQuantity(String userId, String productId, int quantity) async {
    try {
      await _client
          .from('cart_items')
          .update({'quantity': quantity})
          .match({'user_id': userId, 'product_id': productId});
    } catch (e) {
      print('Error al actualizar cantidad en Supabase: $e');
    }
  }

  @override
  Future<void> removeFromRemoteCart(String userId, String productId) async {
    try {
      await _client
          .from('cart_items')
          .delete()
          .match({'user_id': userId, 'product_id': productId});
    } catch (e) {
      print('Error al eliminar del carrito en Supabase: $e');
    }
  }

  @override
  Future<void> clearRemoteCart(String userId) async {
    try {
      await _client.from('cart_items').delete().eq('user_id', userId);
    } catch (e) {
      print('Error al limpiar carrito en Supabase: $e');
    }
  }
}
