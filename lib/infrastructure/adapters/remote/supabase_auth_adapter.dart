import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/user.dart';
import '../../../domain/ports/auth_repository.dart';

/// CAPA DE INFRAESTRUCTURA - Adaptador Remoto
/// Implementación concreta del puerto [AuthRepository] usando Supabase Auth.
///
/// PATRÓN HEXAGONAL: Este es un "Adaptador de Salida". Traduce las llamadas del
/// dominio en operaciones específicas de Supabase Auth + tabla `users`.
/// El dominio y los casos de uso no saben que Supabase existe.
class SupabaseAuthAdapter implements AuthRepository {
  final _client = Supabase.instance.client;

  /// Inicia sesión con email y contraseña usando Supabase Auth.
  /// Luego carga el perfil extendido desde la tabla `users`.
  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final authUser = response.user;
      if (authUser == null) return null;

      return await _fetchUserProfile(authUser.id, email);
    } on AuthException {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Registra un nuevo usuario en Supabase Auth y crea su fila en la tabla `users`.
  ///
  /// Maneja dos escenarios de Supabase:
  /// - Sin confirmación de email: el usuario queda activo de inmediato.
  /// - Con confirmación de email: Supabase devuelve el usuario pero sin sesión;
  ///   en ese caso guardamos el perfil usando service_role implícito via anon key
  ///   con la política de INSERT que permite `auth.uid() = id`.
  @override
  Future<bool> register(UserModel user) async {
    try {
      final response = await _client.auth.signUp(
        email: user.email.trim(),
        password: user.password,
        data: {
          'name': user.name,
          'phone': user.phone,
        },
      );

      final authUser = response.user;
      if (authUser == null) {
        // Supabase devolvió null: el correo ya existe o hay un error de red.
        throw Exception('No se pudo crear la cuenta. Verifica tu correo.');
      }

      // Intenta crear el perfil en la tabla `users`.
      // Si Supabase tiene confirmación de email ON, la sesión no estará activa
      // todavía, pero el JWT del signUp nos permite el insert si RLS está bien.
      try {
        await _client.from('users').insert({
          'id': authUser.id,
          'email': user.email.trim(),
          'phone': user.phone,
          'name': user.name,
        });
      } catch (insertErr) {
        // El insert puede fallar si el email necesita confirmación antes de que
        // RLS permita la escritura. Se registra el error pero el registro de
        // Supabase Auth ya fue exitoso — el perfil se creará al confirmar.
        // ignore: avoid_print
        print('[SupabaseAuthAdapter] users insert warning: $insertErr');
      }

      return true;
    } on AuthException catch (e) {
      // ignore: avoid_print
      print('[SupabaseAuthAdapter] AuthException: ${e.message}');
      throw Exception(_translateAuthError(e.message));
    } catch (e) {
      // ignore: avoid_print
      print('[SupabaseAuthAdapter] register error: $e');
      rethrow;
    }
  }

  /// Traduce los mensajes de error de Supabase Auth al español.
  String _translateAuthError(String message) {
    if (message.contains('already registered') ||
        message.contains('already been registered') ||
        message.contains('User already registered')) {
      return 'Este correo ya está registrado.';
    }
    if (message.contains('Password should be at least')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (message.contains('Unable to validate email')) {
      return 'El correo electrónico no es válido.';
    }
    if (message.contains('Email rate limit exceeded')) {
      return 'Demasiados intentos. Espera unos minutos.';
    }
    return message;
  }

  /// Cierra la sesión del usuario actual en Supabase.
  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  /// Recupera el usuario actualmente autenticado desde Supabase Auth
  /// y enriquece el modelo con los datos de la tabla `users`.
  @override
  Future<UserModel?> getCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) return null;
    return await _fetchUserProfile(authUser.id, authUser.email ?? '');
  }

  // ── Métodos privados ──────────────────────────────────────────────────────

  /// Carga el perfil del usuario desde la tabla `users` de Supabase.
  Future<UserModel?> fetchUserProfile(String id, String email) =>
      _fetchUserProfile(id, email);

  Future<UserModel?> _fetchUserProfile(String id, String email) async {
    try {
      final data = await _client
          .from('users')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (data == null) {
        // Perfil aún no creado (ej. confirmación de email pendiente).
        return UserModel(
          id: id,
          email: email,
          password: '',
          phone: '',
        );
      }

      return UserModel.fromJson(data);
    } catch (_) {
      return UserModel(id: id, email: email, password: '', phone: '');
    }
  }
}
