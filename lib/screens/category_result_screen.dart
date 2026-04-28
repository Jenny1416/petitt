import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/logo.dart';
import '../widgets/product_card.dart';

class CategoryResultScreen extends StatelessWidget {
  final String category;
  const CategoryResultScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    // Filtramos por categoría (animal)
    final results = app.products.where((p) => 
      category == 'Todos' || p.category.toLowerCase() == category.toLowerCase()
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const PetitLogo(size: 34),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            icon: Badge(
              label: Text('${app.cart.length}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Categoría: $category',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('No hay productos en esta categoría.'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: results.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (_, i) => ProductCard(p: results[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
