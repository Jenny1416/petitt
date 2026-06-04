import '../../domain/models/product.dart';
import '../../domain/ports/product_repository.dart';

/// CAPA DE APLICACIÓN - Caso de Uso
/// Recupera la lista completa de productos disponibles.
/// 
/// PATRÓN HEXAGONAL: El caso de uso actúa como frontera. La UI no pide los 
/// productos directamente a la base de datos, sino que pasa por aquí para 
/// aplicar cualquier regla de negocio necesaria en el futuro.
class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase(this._productRepository);

  /// Ejecuta la obtención de productos a través del puerto definido.
  Future<List<Product>> execute() async {
    return await _productRepository.getProducts();
  }
}
