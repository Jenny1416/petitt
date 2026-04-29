import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AnimalCategories extends StatelessWidget {
  const AnimalCategories({super.key});

  @override
  Widget build(BuildContext context) {
    const animals = [
      {'n': 'Hamsters', 'i': 'https://images.unsplash.com/photo-1548767797-d8c844163c4c?w=100'},
      {'n': 'Pájaros', 'i': 'https://images.unsplash.com/photo-1522926193341-e9fed196d4ad?w=100'},
      {'n': 'Perros', 'i': 'https://images.unsplash.com/photo-1517849845537-4d257902454a?w=100'},
      {'n': 'Gatos', 'i': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=100'},
      {'n': 'Pescados', 'i': 'https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?w=100'},
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
                    backgroundImage: NetworkImage(animals[i]['i']!),
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
