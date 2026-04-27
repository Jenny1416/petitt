import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/primary_button.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_image.dart';
import '../widgets/onboarding_text.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingPage02 extends StatelessWidget {
  const OnboardingPage02({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const OnboardingHeader(stepText: '2/2'),
              const SizedBox(height: 24),
              const OnboardingImage(
                  imagePath: 'assets/images/onboarding_02.jpg'),
              const SizedBox(height: 24),
              const OnboardingText(
                title: 'Recibe en Casa',
                description:
                    'Realiza tus pedidos de forma segura y recíbelos en la puerta de tu hogar. '
                    '¡Hacer feliz a tu mascota nunca fue tan fácil!',
              ),
              const SizedBox(height: 24),
              const OnboardingIndicator(currentPage: 1, totalPages: 2),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Empezar',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.onboarding,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
