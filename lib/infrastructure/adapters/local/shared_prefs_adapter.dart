import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/ports/local_storage_repository.dart';

/// CAPA DE INFRAESTRUCTURA - Adaptador
/// Implementación concreta del puerto 'LocalStorageRepository' usando SharedPreferences.
/// 
/// PATRÓN HEXAGONAL: Este es un "Adaptador de Salida". Transforma las llamadas del 
/// dominio en operaciones específicas de la tecnología SharedPreferences.
class SharedPrefsAdapter implements LocalStorageRepository {
  static const String _favKey = 'favorite_ids';
  static const String _sessionKey = 'user_session';
  static const String _onboardingKey = 'onboarding_complete';
  static const String _addressesKey = 'user_addresses';

  @override
  Future<void> saveFavorites(List<String> productIds) async {
    final prefs = await SharedPreferences.getInstance();
    // PERSISTENCIA: Almacenamos la lista de IDs como un StringList.
    await prefs.setStringList(_favKey, productIds);
  }

  @override
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favKey) ?? [];
  }

  @override
  Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    // PERSISTENCIA: Guardamos el email para simular una sesión activa.
    await prefs.setString(_sessionKey, email);
  }

  @override
  Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  @override
  Future<void> saveOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  @override
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  @override
  Future<void> saveAddresses(List<Map<String, String>> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(addresses);
    await prefs.setString(_addressesKey, encoded);
  }

  @override
  Future<List<Map<String, String>>> getAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_addressesKey);
    if (encoded == null) return [];
    
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((e) => Map<String, String>.from(e)).toList();
  }
}
