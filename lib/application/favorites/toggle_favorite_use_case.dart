import '../../domain/ports/local_storage_repository.dart';

/// CAPA DE APLICACIÓN - Caso de Uso
/// Gestiona la lógica de agregar o quitar un producto de la lista de favoritos.
/// 
/// PATRÓN HEXAGONAL: Este caso de uso coordina el cambio de estado en memoria 
/// y su persistencia a través del puerto 'LocalStorageRepository'.
class ToggleFavoriteUseCase {
  final LocalStorageRepository _localStorageRepository;

  ToggleFavoriteUseCase(this._localStorageRepository);

  /// Ejecuta la acción de alternar favorito.
  /// 
  /// GETX + SHARPREFERENCES: 
  /// 1. Modifica la lista reactiva de GetX que viene de la UI.
  /// 2. Persiste la nueva lista en SharedPreferences usando el adaptador.
  Future<void> execute(List<String> currentFavorites, String productId) async {
    if (currentFavorites.contains(productId)) {
      currentFavorites.remove(productId);
    } else {
      currentFavorites.add(productId);
    }
    
    // PERSISTENCIA: Sincroniza el cambio con el almacenamiento local.
    await _localStorageRepository.saveFavorites(currentFavorites);
  }
}
