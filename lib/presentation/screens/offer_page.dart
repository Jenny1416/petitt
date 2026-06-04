import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../infrastructure/state/controllers/product_controller.dart';
import '../../infrastructure/state/controllers/cart_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/logo.dart';
import '../widgets/product_card.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const PetitLogo(size: 34),
        centerTitle: false,
        backgroundColor: const Color(0xff123516),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.cart),
            icon: Obx(() => Badge(
              label: Text('${cartController.cartItems.length}'),
              child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            )),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xff123516),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Venta Flash',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '50% a 60% de descuento acumulado',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final offerProducts = productController.products.where((p) => p.discount >= 50).toList();
              if (offerProducts.isEmpty) {
                return const Center(child: Text('No hay ofertas flash disponibles.'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: offerProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(p: offerProducts[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
