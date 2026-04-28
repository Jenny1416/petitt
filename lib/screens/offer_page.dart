import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
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
        title: const Text('Venta Flash - 50% a 60% OFF'),
        backgroundColor: const Color(0xff123516),
        foregroundColor: Colors.white,
      ),
      body: offerProducts.isEmpty
          ? const Center(
              child: Text('No hay ofertas flash disponibles en este momento.'))
          : GridView.builder(
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
            ),
    );
  }
}
