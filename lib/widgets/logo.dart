import 'package:flutter/material.dart';

class PetitLogo extends StatelessWidget {
  final double size;
  const PetitLogo({super.key, this.size = 64});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: const Color(0xff113d18),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 8)
              ]),
          child: Icon(Icons.pets, color: Colors.white, size: size * .45)),
      const SizedBox(width: 8),
      Text('PETIT',
          style: TextStyle(
              fontSize: size * .42,
              fontWeight: FontWeight.w700,
              color: const Color(0xff078818),
              fontFamily: 'Georgia'))
    ]);
  }
}
