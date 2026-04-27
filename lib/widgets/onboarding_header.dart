import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class OnboardingHeader extends StatelessWidget {
  final String stepText;
  const OnboardingHeader({super.key, required this.stepText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          stepText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
          },
          child: const Text('Saltar'),
        ),
      ],
    );
  }
}
