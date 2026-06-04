import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/ports/local_storage_repository.dart';
import '../routes/app_pages.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';

/// CAPA DE PRESENTACIÓN - Pantalla de Bienvenida (Splash)
/// Realiza la verificación inicial del estado de la aplicación
/// (ej. si el onboarding fue completado) interactuando directamente
/// con el puerto [LocalStorageRepository].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const PetitLogo(size: 80),
                const Spacer(),
                PrimaryButton(
                  text: 'Empecemos',
                  onTap: () => Get.toNamed(AppRoutes.register),
                ),
                TextButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  icon: const Icon(Icons.arrow_circle_right),
                  label: const Text('Ya tengo una cuenta'),
                ),
              ],
            ),
          ),
        ),
      );
}
