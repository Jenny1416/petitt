import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Añadir este import
import 'package:flutter/material.dart'; // Añadir para los colores
import '../../../domain/models/user.dart';
import '../../../application/auth/login_use_case.dart';
import '../../../application/auth/register_use_case.dart';
import '../../../domain/ports/auth_repository.dart';

/// CAPA DE INFRAESTRUCTURA / PRESENTACIÓN - Controlador GetX
/// Gestiona el estado de la autenticación y la lógica de la UI para el login y registro.
/// 
/// PATRÓN HEXAGONAL: El controlador actúa como un "Adaptador de Entrada".
/// Escucha eventos de la UI y los delega a los "Casos de Uso".
class AuthController extends GetxController {
  // Casos de Uso inyectados (Capa de Aplicación).
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  // Puerto de Dominio inyectado.
  final AuthRepository _authRepository;

  AuthController(this._loginUseCase, this._registerUseCase, this._authRepository);

  // GESTIÓN DE ESTADO (GetX): 
  // 'Rxn' permite observar cambios en el usuario (incluso si es nulo).
  final Rxn<UserModel> _currentUser = Rxn<UserModel>();
  UserModel? get currentUser => _currentUser.value;

  // '.obs' convierte una variable simple en un flujo reactivo.
  final RxBool isLoading = false.obs;

  /// Llama al caso de uso de Login.
  /// 
  /// GETX + SHARPREFERENCES: El 'LoginUseCase' se encargará de validar
  /// las credenciales y persistir la sesión usando el adaptador de SharedPreferences.
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    final user = await _loginUseCase.execute(email, password);
    _currentUser.value = user;
    isLoading.value = false;
    return user != null;
  }

  Future<void> requestPasswordReset(String email) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  Future<bool> updatePassword(String newPassword) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    return true;
  }

  /// Llama al caso de uso de Registro.
  Future<bool> register(String email, String password, String phone) async {
    try {
      isLoading.value = true;
      final success = await _registerUseCase.execute(email, password, phone);
      if (success) {
        _currentUser.value = await _authRepository.getCurrentUser();
      }
      return success;
    } catch (e) {
      // Capturamos el error real de Supabase o del sistema
      String errorMessage = 'Error al registrar usuario';
      
      if (e is AuthException) {
        errorMessage = e.message;
      }
      
      Get.snackbar(
        'Registro Fallido',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xffD4933E).withOpacity(0.1),
        colorText: Color(0xff123516),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Cierra la sesión limpiando el almacenamiento local.
  void logout() {
    _authRepository.logout();
    _currentUser.value = null;
  }

  /// Actualiza la información del usuario de forma reactiva.
  void updateUserInfo(String name, String phone) {
    if (_currentUser.value != null) {
      _currentUser.value!.name = name;
      _currentUser.value!.phone = phone;
      // '.refresh()' notifica a todos los widgets Obx que el objeto interno cambió.
      _currentUser.refresh();
    }
  }
}
