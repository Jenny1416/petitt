/// CAPA DE DOMINIO - Puerto (Interface)
/// Define el contrato para la persistencia local de la aplicación.
/// 
/// PATRÓN HEXAGONAL: Este es un "Puerto de Salida". El dominio define qué necesita
/// (guardar favoritos, sesión, etc.) sin preocuparse de cómo se implementa 
/// (SharedPreferences, Hive, SQLite, etc.).
abstract class LocalStorageRepository {
  /// Guarda la lista de IDs de productos marcados como favoritos.
  Future<void> saveFavorites(List<String> productIds);
  
  /// Recupera la lista de IDs de favoritos almacenados.
  Future<List<String>> getFavorites();
  
  /// Persiste el email del usuario para mantener la sesión activa.
  Future<void> saveSession(String email);
  
  /// Recupera el email de la sesión actual si existe.
  Future<String?> getSession();
  
  /// Elimina los datos de sesión (Logout).
  Future<void> clearSession();
  
  /// Marca que el usuario ya vio la introducción (Onboarding).
  Future<void> saveOnboardingComplete();
  
  /// Verifica si el usuario ya completó el onboarding.
  Future<bool> isOnboardingComplete();

  /// Guarda la lista de direcciones del usuario.
  Future<void> saveAddresses(List<Map<String, String>> addresses);

  /// Recupera la lista de direcciones guardadas.
  Future<List<Map<String, String>>> getAddresses();
}
