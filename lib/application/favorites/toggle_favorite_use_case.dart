import '../../domain/ports/product_repository.dart';
import '../../domain/ports/local_storage_repository.dart';

/// CAPA DE APLICACIÓN - Caso de Uso
/// Gestiona la lógica de agregar o quitar un producto de la lista de favoritos.
class ToggleFavoriteUseCase {
  final ProductRepository _productRepository;
  final LocalStorageRepository _localStorageRepository;

  ToggleFavoriteUseCase(this._productRepository, this._localStorageRepository);

  /// Ejecuta la acción de alternar favorito.
  /// Sincroniza tanto con Supabase (remoto) como con SharedPreferences (local para offline).
  Future<void> execute(List<String> currentFavorites, String productId, String userId) async {
    final isAdding = !currentFavorites.contains(productId);
    
    if (isAdding) {
      currentFavorites.add(productId);
    } else {
      currentFavorites.remove(productId);
    }
    
    // PERSISTENCIA LOCAL: Para acceso rápido y offline.
    await _localStorageRepository.saveFavorites(currentFavorites);

    // PERSISTENCIA REMOTA: Sincroniza con Supabase.
    await _productRepository.toggleFavorite(userId, productId, isAdding);
  }
}
