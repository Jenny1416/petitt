/// CAPA DE DOMINIO - Modelo
/// Entidad que representa a un usuario dentro del sistema.
///
/// PATRÓN HEXAGONAL: Los modelos son agnósticos a la persistencia y al framework.
class UserModel {
  String? id; // UUID de Supabase Auth
  String email, password, phone, name;
  List<Map<String, String>> addresses;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.phone,
    this.name = 'Usuario PETIT',
    this.addresses = const [],
  });

  /// Convierte el modelo a un Map para insertar/actualizar en Supabase.
  /// La contraseña nunca se persiste en la tabla; la gestiona Supabase Auth.
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
        'name': name,
      };

  /// Crea un UserModel a partir de una fila de la tabla `users` en Supabase.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String?,
        email: json['email'] as String? ?? '',
        password: '', // La contraseña no se almacena en la tabla
        phone: json['phone'] as String? ?? '',
        name: json['name'] as String? ?? 'Usuario PETIT',
      );
}

