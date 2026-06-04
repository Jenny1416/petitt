/// CAPA DE DOMINIO - Modelo
/// Entidad que representa a un usuario dentro del sistema.
/// 
/// PATRÓN HEXAGONAL: Los modelos son agnósticos a la persistencia y al framework.
class UserModel {
  String email, password, phone, name;
  List<Map<String, String>> addresses;

  UserModel({
    required this.email,
    required this.password,
    required this.phone,
    this.name = 'Usuario PETIT',
    this.addresses = const [],
  });
}
