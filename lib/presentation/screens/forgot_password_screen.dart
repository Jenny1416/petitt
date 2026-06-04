import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../infrastructure/state/controllers/auth_controller.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController(text: 'demo@petit.com');
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35),
                    const Center(child: PetitLogo(size: 70)),
                    const SizedBox(height: 45),
                    const Text('¿Has olvidado tu contraseña?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 18),
                    TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Correo electrónico',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                    const SizedBox(height: 8),
                    Text(
                        'Le enviaremos un mensaje para restablecer su nueva contraseña',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(height: 24),
                    Obx(() => PrimaryButton(
                        text: authController.isLoading.value ? 'Enviando...' : 'Enviar',
                        onTap: authController.isLoading.value ? null : () async {
                          await authController.requestPasswordReset(emailController.text);
                          Get.snackbar('Éxito', 'Se ha enviado un correo de verificación');
                          Get.toNamed('/new-password');
                        }))
                  ]))));
}
