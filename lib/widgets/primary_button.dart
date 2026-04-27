import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const PrimaryButton({super.key, required this.text, this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: const Color(0xff078818),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
          onPressed: onTap,
          child: Text(text,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))));
}
