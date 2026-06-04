import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../state/controllers/product_controller.dart';
import '../../state/controllers/cart_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/logo.dart';
import '../widgets/product_card.dart';

class CategoryResultScreen extends StatelessWidget {
  final String? category;
  const CategoryResultScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final CartController cartController = Get.find<CartController>();
    final String finalCategory = category ?? Get.arguments as String;
    
    return Scaffold(
      appBar: AppBar(
        title: const PetitLogo(size: 34),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.cart),
            icon: Obx(() => Badge(
              label: Text('${cartController.cartItems.length}'),
              child: const Icon(Icons.shopping_cart_outlined),
            )),
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
              'Categoría: $finalCategory',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Obx(() {
              final results = productController.products.where((p) => 
                finalCategory == 'Todos' || p.category.toLowerCase() == finalCategory.toLowerCase()
              ).toList();

              if (results.isEmpty) {
                return const Center(child: Text('No hay productos en esta categoría.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: results.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (_, i) => ProductCard(p: results[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}
