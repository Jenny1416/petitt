import 'package:flutter/material.dart';

class OnboardingImage extends StatelessWidget {
  final String imagePath;
  const OnboardingImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Image.asset(
          imagePath, // 👈 aquí pones tu imagen desde tu PC
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
