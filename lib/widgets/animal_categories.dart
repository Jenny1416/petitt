import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AnimalCategories extends StatelessWidget {
  const AnimalCategories({super.key});

  @override
  Widget build(BuildContext context) {
    const animals = [
      {'n': 'Hamsters', 'i': 'assets/images/hamster.jpg'},
      {'n': 'Pájaros', 'i': 'assets/images/pajaro.jpg'},
      {'n': 'Perros', 'i': 'assets/images/perro.jpg'},
      {'n': 'Gatos', 'i': 'assets/images/gato.jpg'},
      {'n': 'Pescados', 'i': 'assets/images/pez.jpg'},
    ];

    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: animals.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.categoryResult, arguments: animals[i]['n']),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xffD4933E).withOpacity(0.3), width: 1.5),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: AssetImage(animals[i]['i']!),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  animals[i]['n']!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff123516),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
