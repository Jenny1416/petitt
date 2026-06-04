import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/product.dart';
import '../../../domain/models/review.dart';
import '../../../domain/ports/product_repository.dart';

/// CAPA DE INFRAESTRUCTURA - Adaptador Remoto
/// Implementación concreta del puerto [ProductRepository] usando Supabase.
///
/// PATRÓN HEXAGONAL: Este adaptador reemplaza al [JsonProductAdapter].
/// El dominio sigue usando el mismo puerto; solo cambia la fuente de datos.
class SupabaseProductAdapter implements ProductRepository {
  final _client = Supabase.instance.client;

  // Caché en memoria para evitar llamadas repetidas a Supabase.
  List<Product>? _cachedProducts;

  /// Recupera todos los productos activos desde la tabla `products`.
  /// Incluye las reseñas relacionadas via join con la tabla `reviews`.
  @override
  Future<List<Product>> getProducts() async {
    if (_cachedProducts != null) return _cachedProducts!;

    final data = await _client
        .from('products')
        .select('*, reviews(*)')
        .order('name');

    _cachedProducts = (data as List)
        .map((row) => Product.fromJson(row as Map<String, dynamic>))
        .toList();

    return _cachedProducts!;
  }

  /// Añade una reseña al producto en la tabla `reviews` y actualiza el rating.
  @override
  Future<void> addReview(String productId, ReviewModel review) async {
    // Insertar la reseña en la tabla `reviews`.
    await _client.from('reviews').insert({
      ...review.toJson(),
      'product_id': productId,
    });

    // Invalidar caché para reflejar el nuevo rating en la próxima carga.
    _cachedProducts = null;

    // Actualizar localmente el producto en caché si ya estaba cargado.
    final products = await getProducts();
    try {
      final product = products.firstWhere((p) => p.id == productId);
      product.reviews.add(review);
      final totalStars =
          product.reviews.fold(0.0, (prev, r) => prev + r.rating);
      product.rating = totalStars / product.reviews.length;

      // Persistir el nuevo rating en Supabase.
      await _client
          .from('products')
          .update({'rating': product.rating}).eq('id', productId);
    } catch (_) {
      // Producto no encontrado en caché; no hay nada más que hacer.
    }
  }

  /// Descuenta el stock del producto tras una compra.
  @override
  Future<void> updateStock(String productId, int quantity) async {
    // Obtener stock actual desde la BD.
    final data = await _client
        .from('products')
        .select('stock')
        .eq('id', productId)
        .single();

    final currentStock = data['stock'] as int;
    final newStock = (currentStock - quantity).clamp(0, 999999);

    await _client
        .from('products')
        .update({'stock': newStock}).eq('id', productId);

    // Actualizar caché local.
    if (_cachedProducts != null) {
      try {
        final product =
            _cachedProducts!.firstWhere((p) => p.id == productId);
        product.stock = newStock;
      } catch (_) {}
    }
  }
}
