import 'package:flutter/material.dart';

class CategoryChipList extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final isSelected = selectedCategory == categories[i];
          return ChoiceChip(
            label: Text(categories[i]),
            selected: isSelected,
            onSelected: (_) => onSelected(categories[i]),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xff123516),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
            selectedColor: const Color(0xff123516),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: isSelected ? const Color(0xff123516) : Colors.grey.shade200,
              ),
            ),
            elevation: isSelected ? 4 : 0,
            shadowColor: const Color(0xff123516).withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          );
        },
      ),
    );
  }
}
