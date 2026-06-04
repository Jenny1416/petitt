import '../models/user.dart';

/// CAPA DE DOMINIO - Puerto (Interface)
/// Define el contrato para la autenticación de usuarios.
/// 
/// PATRÓN HEXAGONAL: Este puerto permite que el dominio solicite acciones de 
/// autenticación sin conocer si los datos están en memoria, en una DB o en la nube.
abstract class AuthRepository {
  /// Intenta iniciar sesión con las credenciales proporcionadas.
  Future<UserModel?> login(String email, String password);
  
  /// Registra un nuevo usuario en el sistema.
  Future<bool> register(UserModel user);
  
  /// Finaliza la sesión actual.
  Future<void> logout();
  
  /// Obtiene el usuario autenticado actualmente.
  Future<UserModel?> getCurrentUser();
}
