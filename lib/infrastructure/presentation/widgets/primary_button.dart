import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final bool isLoading;

  const PrimaryButton({
    super.key, 
    required this.text, 
    this.onTap, 
    this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xff123516),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: isLoading ? null : onTap,
        child: isLoading 
          ? const SizedBox(
              height: 20, 
              width: 20, 
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
      ),
    );
  }
}
