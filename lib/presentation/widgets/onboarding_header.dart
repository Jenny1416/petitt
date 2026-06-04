import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

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
            Get.offAllNamed(AppRoutes.onboarding);
          },
          child: const Text('Saltar'),
        ),
      ],
    );
  }
}
