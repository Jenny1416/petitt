import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/user.dart';
import '../../../domain/ports/auth_repository.dart';

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
      final response = await _client.auth.signUp(
        email: user.email,
        password: user.password,
        data: {
          'full_name': user.name,
          'phone': user.phone, // Se guarda en raw_user_meta_data
        },
      );
      return response.user != null;
    } on AuthException catch (e) {
      print('DEBUG Supabase: ${e.message}');
      rethrow;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async => await _client.auth.signOut();

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    return user != null ? _mapToDomain(user) : null;
  }

  UserModel _mapToDomain(User user) {
    // IMPORTANTE: Extraemos el teléfono de la metadata
    final metadata = user.userMetadata ?? {};
    return UserModel(
      email: user.email ?? '',
      password: '',
      name: metadata['full_name'] ?? 'Usuario PETIT',
      phone: metadata['phone'] ?? '', // Aquí recuperamos lo que guardamos
    );
  }
}
