import 'package:flutter/material.dart';

class CustomTag extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;

  const CustomTag({
    super.key,
    required this.text,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? const Color(0xffD4933E);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeColor.withOpacity(0.5), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? themeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
