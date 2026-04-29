import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/primary_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Ilustración/Imagen superior con forma curva
          Positioned(
            top: -50,
            left: -50,
            right: -50,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/onboarding_bg.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(400, 150),
                ),
              ),
            ),
          ),

          // Contenido inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'PETIT',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff123516),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mascotas felices, tú feliz.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff123516),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mantén a tus amigos peludos sanos, felices y bien cuidados con herramientas inteligentes y servicios para mascotas de confianza.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: 'Comience',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.home);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
