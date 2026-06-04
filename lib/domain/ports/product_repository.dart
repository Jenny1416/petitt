import '../models/product.dart';
import '../models/review.dart';

/// CAPA DE DOMINIO - Puerto (Interface)
/// Define el contrato para la gestión de productos e inventario.
/// 
/// PATRÓN HEXAGONAL: El dominio define las operaciones de productos. 
/// La implementación (Adaptador) puede ser un archivo JSON local o una API remota.
abstract class ProductRepository {
  /// Recupera todos los productos disponibles.
  Future<List<Product>> getProducts();
  
  /// Añade una nueva reseña a un producto específico.
  Future<void> addReview(String productId, ReviewModel review);
  
  /// Actualiza la cantidad disponible (stock) de un producto.
  Future<void> updateStock(String productId, int quantity);
}
