import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/logo.dart';
import '../widgets/primary_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
                  onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                  icon: const Icon(Icons.arrow_circle_right),
                  label: const Text('Ya tengo una cuenta'),
                ),
              ],
            ),
          ),
        ),
      );
}
