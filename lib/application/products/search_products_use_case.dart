import '../../domain/models/product.dart';

/// CAPA DE APLICACIÓN - Caso de Uso
/// Implementa la lógica de filtrado y búsqueda de productos.
class SearchProductsUseCase {
  List<Product> execute(List<Product> allProducts, String query, String categoryOrType) {
    return allProducts.where((p) =>
      (categoryOrType == 'Todos' || p.category == categoryOrType || p.type == categoryOrType) &&
      (query.isEmpty || p.name.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }
}
