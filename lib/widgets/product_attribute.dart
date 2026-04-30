import 'package:flutter/material.dart';

class ProductAttribute extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProductAttribute({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xff123516).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xff123516), size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff123516)),
          ),
        ],
      ),
    );
  }
}
