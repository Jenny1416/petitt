/// CAPA DE INFRAESTRUCTURA - Configuración
/// Centraliza las credenciales de conexión con Supabase.
///
/// PATRÓN HEXAGONAL: Solo los adaptadores de infraestructura (adapters/remote/)
/// deben importar este archivo. El Dominio y los Casos de Uso nunca lo ven.
class SupabaseConfig {
  SupabaseConfig._();

  /// URL del proyecto Supabase.
  static const String url = 'https://ljdpunxhzbuoarnzeowa.supabase.co';

  /// Clave pública (anon key) para el cliente de Flutter.
  static const String anonKey =
      'sb_publishable_xKVU3rQx3lPQn6InqfgJYA_ByMCppt9';
}
