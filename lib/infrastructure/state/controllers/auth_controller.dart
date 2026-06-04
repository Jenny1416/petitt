import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/user.dart';
import '../../../application/auth/login_use_case.dart';
import '../../../application/auth/register_use_case.dart';
import '../../../domain/ports/auth_repository.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthRepository _authRepository;

  AuthController(this._loginUseCase, this._registerUseCase, this._authRepository);

  final Rxn<UserModel> rxCurrentUser = Rxn<UserModel>();
  UserModel? get currentUser => rxCurrentUser.value;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialSession();
  }

  Future<void> _checkInitialSession() async {
    final user = await _authRepository.getCurrentUser();
    rxCurrentUser.value = user;
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    final user = await _loginUseCase.execute(email, password);
    rxCurrentUser.value = user;
    isLoading.value = false;
    return user != null;
  }

  Future<void> requestPasswordReset(String email) async {
    isLoading.value = true;
    // Simulación o implementación con Supabase:
    // await Supabase.instance.client.auth.resetPasswordForEmail(email);
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  Future<bool> updatePassword(String newPassword) async {
    isLoading.value = true;
    // await Supabase.instance.client.auth.updateUser(UserAttributes(password: newPassword));
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    return true;
  }

  Future<bool> register(String email, String password, String phone) async {
    try {
      isLoading.value = true;
      final success = await _registerUseCase.execute(email, password, phone);
      if (success) {
        rxCurrentUser.value = await _authRepository.getCurrentUser();
      }
      return success;
    } catch (e) {
      String errorMessage = 'Error al registrar usuario';
      if (e is AuthException) errorMessage = e.message;
      
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

  void logout() {
    _authRepository.logout();
    rxCurrentUser.value = null;
  }

  void updateUserInfo(String name, String phone) {
    if (rxCurrentUser.value != null) {
      rxCurrentUser.value!.name = name;
      rxCurrentUser.value!.phone = phone;
      rxCurrentUser.refresh();
    }
  }
}
