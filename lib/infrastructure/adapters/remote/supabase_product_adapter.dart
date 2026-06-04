import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/product.dart';
import '../../../domain/ports/product_repository.dart';
import '../../../domain/models/review.dart';

/// ADAPTADOR DE INFRAESTRUCTURA (Remote)
/// Implementa la conexión con la tabla 'products' de Supabase.
class SupabaseProductAdapter implements ProductRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Product>> getProducts() async {
    try {
      // Consultamos la tabla 'products'
      final List<dynamic> response = await _client
          .from('products')
          .select()
          .order('name', ascending: true);
      
      return response.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('DEBUG Supabase Products Error: $e');
      return []; // Retorna lista vacía en caso de error
    }
  }

  @override
  Future<void> addReview(String productId, ReviewModel review) async {
    // Aquí podrías implementar la lógica para insertar en una tabla 'reviews'
  }

  @override
  Future<void> updateStock(String productId, int quantity) async {
    try {
      await _client
          .from('products')
          .update({'stock': quantity})
          .eq('id', productId);
    } catch (e) {
      print('Error al actualizar stock: $e');
    }
  }
}
