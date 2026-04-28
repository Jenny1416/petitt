import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/logo.dart';
import '../widgets/product_card.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    // Filtramos productos que tengan 50% o 60% de descuento
    final offerProducts = app.products.where((p) => p.discount >= 50).toList();

    return Scaffold(
      appBar: AppBar(
        title: const PetitLogo(size: 34),
        centerTitle: false,
        backgroundColor: const Color(0xff123516),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            icon: Badge(
              label: Text('${app.cart.length}'),
              child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            ),
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
            child: offerProducts.isEmpty
                ? const Center(
                    child: Text('No hay ofertas flash disponibles.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: offerProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(p: offerProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
