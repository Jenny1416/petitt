import 'package:flutter/material.dart';
import 'primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonTap;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonTap,
    this.iconColor,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? const Color(0xff123516).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: iconColor ?? const Color(0xff123516).withOpacity(0.2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff123516),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            if (buttonText != null && onButtonTap != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: PrimaryButton(
                  text: buttonText!,
                  onTap: onButtonTap!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
