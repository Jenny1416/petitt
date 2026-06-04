import '../../domain/models/user.dart';
import '../../domain/ports/auth_repository.dart';
import '../../domain/ports/local_storage_repository.dart';

/// CAPA DE APLICACIÓN - Caso de Uso
/// Coordina el proceso de inicio de sesión.
/// 
/// PATRÓN HEXAGONAL: Esta clase depende de abstracciones (Puertos), permitiendo 
/// cambiar la base de datos o el sistema de auth sin afectar la lógica de negocio.
class LoginUseCase {
  final AuthRepository _authRepository;
  final LocalStorageRepository _localStorageRepository;

  LoginUseCase(this._authRepository, this._localStorageRepository);

  /// Ejecuta la lógica de login:
  /// 1. Autentica contra el repositorio (Puerto).
  /// 2. Si es exitoso, persiste la sesión en SharedPreferences (vía LocalStorageRepository).
  Future<UserModel?> execute(String email, String password) async {
    final user = await _authRepository.login(email, password);
    
    if (user != null) {
      // PERSISTENCIA: Se guarda el estado de la sesión localmente.
      await _localStorageRepository.saveSession(user.email);
    }

    return user;
  }
}
