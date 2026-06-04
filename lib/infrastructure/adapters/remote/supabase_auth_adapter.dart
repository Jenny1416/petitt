import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/user.dart';
import '../../../domain/ports/auth_repository.dart';

/// ADAPTADOR DE INFRAESTRUCTURA (Remote)
/// Implementa la conexión real con Supabase Auth.
class SupabaseAuthAdapter implements AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return _mapToDomain(response.user!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> register(UserModel user) async {
    try {
      // Usamos solo email/pass y guardamos el resto en metadata (data)
      // para evitar errores si el proveedor de SMS no está configurado.
      final response = await _client.auth.signUp(
        email: user.email,
        password: user.password,
        data: {
          'full_name': user.name,
          'phone': user.phone, // Guardamos aquí el teléfono
        },
      );
      return response.user != null;
    } on AuthException catch (e) {
      // Imprimimos el error real en consola para depurar
      print('DEBUG: Error en registro Supabase: ${e.message}');
      rethrow; // Lanzamos para que el controlador lo atrape
    } catch (e) {
      print('DEBUG: Error inesperado: $e');
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user != null) {
      return _mapToDomain(user);
    }
    return null;
  }

  // Helper para mapear el usuario de Supabase al modelo de nuestro Dominio
  UserModel _mapToDomain(User user) {
    return UserModel(
      email: user.email ?? '',
      password: '',
      name: user.userMetadata?['full_name'] ?? 'Usuario PETIT',
      phone: user.userMetadata?['phone'] ?? user.phone ?? '',
    );
  }
}
