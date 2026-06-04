import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/product.dart';
import '../../../domain/ports/product_repository.dart';
import '../../../domain/models/review.dart';

class SupabaseProductAdapter implements ProductRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Product>> getProducts() async {
    try {
      print('PETITT_LOG: Intentando conectar a Supabase...');
      
      // select('*') es lo más seguro para empezar
      final response = await _client
          .from('products')
          .select('*')
          .order('name', ascending: true);
      
      final List<dynamic> data = response as List<dynamic>;
      print('PETITT_LOG: Datos crudos recibidos: ${data.length} items');

      if (data.isEmpty) {
        print('PETITT_LOG: ATENCIÓN - La tabla "products" está vacía o el RLS bloquea la lectura.');
      }

      final products = data.map((json) {
        try {
          return Product.fromJson(json);
        } catch (e) {
          print('PETITT_LOG: Error mapeando producto ID ${json['id']}: $e');
          return null;
        }
      }).whereType<Product>().toList();

      print('PETITT_LOG: Total productos procesados con éxito: ${products.length}');
      return products;

    } catch (e) {
      print('PETITT_LOG: ERROR CRÍTICO en getProducts: $e');
      return []; 
    }
  }

  @override
  Future<void> addReview(String productId, ReviewModel review) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await _client.from('reviews').insert({
        'user_id': userId,
        'product_id': productId,
        'rating': review.rating,
        'comment': review.comment,
      });
    } catch (e) {
      print('Error review: $e');
    }
  }

  @override
  Future<void> updateStock(String productId, int quantity) async {
    try {
      await _client.from('products').update({'stock': quantity}).eq('id', productId);
    } catch (e) {
      print('Error stock: $e');
    }
  }

  @override
  Future<List<String>> getFavoriteIds(String userId) async {
    try {
      final response = await _client.from('favorites').select('product_id').eq('user_id', userId);
      return (response as List).map((item) => item['product_id'].toString()).toList();
    } catch (e) { return []; }
  }

  @override
  Future<void> toggleFavorite(String userId, String productId, bool isAdd) async {
    try {
      if (isAdd) {
        await _client.from('favorites').insert({'user_id': userId, 'product_id': productId});
      } else {
        await _client.from('favorites').delete().eq('user_id', userId).eq('product_id', productId);
      }
    } catch (e) { print('Error fav: $e'); }
  }
}
