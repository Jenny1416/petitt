import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../infrastructure/state/controllers/auth_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';

/// RegisterScreen - Capa de Presentación
/// 
/// Gestiona el registro de nuevos usuarios integrando la captura de imágenes 
/// y la validación de datos a través del [AuthController].
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// Inyección de dependencia para persistir el nuevo usuario en el estado global
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController phone = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
                  'Crear una Cuenta',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xff123516)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Únete a la familia Smart Pet',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 24),
                /// Integración con el sistema de archivos del dispositivo (Infraestructura de Cámara/Galería)
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xffD4933E), width: 2),
                            boxShadow: [
                              /// Uso de .withValues para compatibilidad con Flutter 3.x
                              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xffe8f7ea),
                            backgroundImage: _image != null ? FileImage(_image!) : null,
                            child: _image == null
                                ? const Icon(Icons.person_outline, size: 40, color: Color(0xff123516))
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Color(0xffD4933E), shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  obscureText: true,
                  hintText: 'Contraseña',
                  prefixIcon: Icons.lock_outline,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  hintText: 'Número telefónico',
                  prefixIcon: Icons.phone_outlined,
                ),
                const SizedBox(height: 32),
                /// Botón reactivo que cambia su estado según la ejecución del caso de uso de registro
                Obx(() => PrimaryButton(
                  text: authController.isLoading.value ? 'Cargando...' : 'Hecho',
                  onTap: authController.isLoading.value ? null : () async {
                    if (email.text.isEmpty || pass.text.length < 4) {
                      Get.snackbar(
                        'Error',
                        'Completa los datos. La contraseña debe tener mínimo 4 caracteres.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    
                    /// Llamada al caso de uso de registro en la capa de infraestructura/estado
                    final ok = await authController.register(email.text, pass.text, phone.text);

                    if (ok) {
                      /// Navegación a la fase inicial tras registro exitoso
                      Get.offAllNamed(AppRoutes.onboarding1);
                    } else {
                      Get.snackbar(
                        'Error',
                        'El correo ya existe',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                )),
                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
