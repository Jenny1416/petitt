import '../models/user_model.dart';

/// Clase AuthService: Responsable de la lógica de persistencia y validación de usuarios.
/// Capa de SERVICIOS: No contiene UI, solo lógica de datos y simulación de API.
class AuthService {
  // Simulación de base de datos de usuarios (ArrayList/List)
  final List<UserModel> _users = [
    UserModel(
        email: 'demo@petit.com',
        password: '123456',
        phone: '3001234567',
        name: 'Jennifer Lopez')
  ];
  
  UserModel? currentUser;

  /// Valida las credenciales de un usuario.
  /// Cumple con la "Separación de responsabilidades" al manejar la lógica fuera de las screens.
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulación de latencia de red
    try {
      currentUser = _users.firstWhere((u) =>
          u.email.trim().toLowerCase() == email.trim().toLowerCase() &&
          u.password == password);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Registra un nuevo usuario en la lista dinámica.
  Future<bool> register(String email, String password, String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Validación de existencia (Regla de negocio)
    if (_users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      return false;
    }
    currentUser = UserModel(email: email, password: password, phone: phone);
    _users.add(currentUser!); // Adición a ArrayList
    return true;
  }

  /// Simulación de envío de correo para recuperación de contraseña.
  Future<bool> sendReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _users.any((u) => u.email.toLowerCase() == email.toLowerCase());
  }

  /// Actualización de contraseña en la fuente de datos.
  Future<void> updatePassword(String email, String newPass) async {
    for (final u in _users) {
      if (u.email.toLowerCase() == email.toLowerCase()) {
        u.password = newPass;
      }
    }
  }
}
