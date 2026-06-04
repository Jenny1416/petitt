import '../../domain/models/user.dart';
import '../../domain/ports/auth_repository.dart';

/// CAPA DE APLICACIÓN - Caso de Uso
/// Implementa la lógica para registrar un nuevo usuario.
/// 
/// PATRÓN HEXAGONAL: Desacopla la lógica de creación de usuario de la 
/// infraestructura de persistencia (AuthRepository).
class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  /// Ejecuta el registro de usuario.
  /// 
  /// Recibe datos planos de la UI, los convierte a un modelo de Dominio (UserModel)
  /// y solicita al puerto de infraestructura que lo guarde.
  Future<bool> execute(String email, String password, String phone) async {
    final user = UserModel(
      id: '', // El ID será generado por Supabase/Auth Provider
      email: email, 
      password: password, 
      phone: phone
    );
    return await _authRepository.register(user);
  }
}
