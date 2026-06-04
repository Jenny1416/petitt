import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../infrastructure/state/controllers/auth_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';

/// LoginScreen - Capa de Presentación
/// 
/// Esta pantalla gestiona la autenticación de usuarios. 
/// Sigue el principio de responsabilidad única al delegar la lógica de negocio
/// y la gestión de estado al [AuthController].
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Inyección de dependencia del controlador de autenticación (Capa de Infraestructura/Estado)
  final AuthController authController = Get.find<AuthController>();
  
  final TextEditingController email = TextEditingController(text: 'demo@petit.com'),
      pass = TextEditingController(text: '123456');
  bool ob = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 45),
                const Center(child: PetitLogo(size: 70)),
                const SizedBox(height: 40),
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xff123516)),
                ),
                const SizedBox(height: 8),
                Text(
                  '¡Qué bueno verte de nuevo!',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Correo electrónico',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: pass,
                  obscureText: ob,
                  hintText: 'Contraseña',
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(ob ? Icons.visibility_off : Icons.visibility, color: const Color(0xff123516)),
                    onPressed: () => setState(() => ob = !ob),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Get.toNamed(AppRoutes.forgotPassword),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),
                const SizedBox(height: 24),
                /// Uso de Obx para reaccionar a cambios en el estado reactivo del controlador.
                /// Esto permite redibujar solo el botón cuando cambia [isLoading].
                Obx(() => PrimaryButton(
                  text: authController.isLoading.value ? 'Validando...' : 'Ingresar',
                  onTap: authController.isLoading.value
                      ? null
                      : () async {
                          // Comunicación con la capa de infraestructura para ejecutar el caso de uso de Login
                          final ok = await authController.login(email.text, pass.text);

                          if (ok) {
                            // Navegación reactiva usando GetX
                            Get.offAllNamed(AppRoutes.home);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Correo o contraseña incorrectos',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                )),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Get.toNamed(AppRoutes.register),
                    child: const Text('Crear cuenta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

