import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/primary_button.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_image.dart';
import '../widgets/onboarding_text.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingPage01 extends StatelessWidget {
  const OnboardingPage01({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const OnboardingHeader(stepText: '1/2'),
              const SizedBox(height: 24),
              const OnboardingImage(
                  imagePath: 'assets/images/onboarding_01.jpg'),
              const SizedBox(height: 24),
              const OnboardingText(
                title: 'Seleccionar Productos',
                description:
                    'Explora nuestro amplio catálogo de productos premium para tu mascota. '
                    'Desde alimentos nutritivos hasta los juguetes más divertidos.',
              ),
              const SizedBox(height: 24),
              const OnboardingIndicator(currentPage: 0, totalPages: 2),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Siguiente',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.onboarding2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
