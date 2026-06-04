import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../infrastructure/state/controllers/auth_controller.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController p1 = TextEditingController(), p2 = TextEditingController();
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
                    const SizedBox(height: 30),
                    const Center(child: PetitLogo(size: 70)),
                    const SizedBox(height: 50),
                    const Text('Crear nueva contraseña',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                        controller: p1,
                        obscureText: true,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Nueva contraseña',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                    const SizedBox(height: 12),
                    TextField(
                        controller: p2,
                        obscureText: true,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Confirmar nueva contraseña',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                    const SizedBox(height: 24),
                    Obx(() => PrimaryButton(
                        text: authController.isLoading.value ? 'Actualizando...' : 'Actualizar Contraseña',
                        onTap: authController.isLoading.value ? null : () async {
                          if (p1.text != p2.text || p1.text.length < 4) {
                            Get.snackbar('Error', 'Las contraseñas no coinciden o son muy cortas');
                            return;
                          }
                          
                          bool success = await authController.updatePassword(p1.text);
                          
                          if (success) {
                            Get.dialog(AlertDialog(
                                        icon: const Icon(Icons.verified,
                                            color: Color(0xff078818), size: 60),
                                        content: const Text(
                                            'Tu contraseña se ha actualizado con éxito',
                                            textAlign: TextAlign.center),
                                        actions: [
                                          PrimaryButton(
                                              text: 'Continuar',
                                              onTap: () => Get.offAllNamed('/login'))
                                        ]));
                          }
                        }))
                  ]))));
}
