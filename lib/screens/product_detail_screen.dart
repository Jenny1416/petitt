import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../widgets/primary_button.dart';
import 'cart_screen.dart';
import 'reviews_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    // Obtenemos el producto actualizado del estado global
    final currentProduct = app.products.firstWhere(
      (p) => p.id == product.id, 
      orElse: () => product
    );

    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              onPressed: () => app.toggleFavorite(currentProduct),
              icon: Icon(
                  app.isFav(currentProduct) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.pink)),
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartScreen())),
              icon: const Icon(Icons.shopping_cart_outlined))
        ]),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(currentProduct.image,
                          height: 210,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              height: 210,
                              color: Colors.grey.shade100,
                              child: const Icon(Icons.pets, size: 80))))),
              const SizedBox(height: 12),
              Wrap(
                  spacing: 8,
                  children: currentProduct.tags
                      .map((t) => Chip(
                          label: Text(t),
                          backgroundColor: const Color(0xffe8f7ea)))
                      .toList()),
              Text(currentProduct.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 21)),
              Text(currentProduct.brand,
                  style: TextStyle(color: Colors.grey.shade600)),
              Row(children: [
                Text('\$${currentProduct.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text('\$${currentProduct.oldPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey)),
                const Spacer(),
                const Icon(Icons.star, color: Colors.amber),
                Text(currentProduct.rating.toStringAsFixed(1))
              ]),
              const SizedBox(height: 12),
              Text(currentProduct.description),
              const SizedBox(height: 12),
              Text('Disponibilidad: ${currentProduct.stock} unidades',
                  style: const TextStyle(
                      color: Color(0xff078818), fontWeight: FontWeight.bold)),
              const Divider(height: 30),
              ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.reviews, color: Color(0xff078818)),
                  title: const Text('Calificaciones y reseñas'),
                  subtitle: Text('Ver ${currentProduct.reviews.length} opiniones de otros compradores'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ReviewsScreen(product: currentProduct)))),
              const SizedBox(height: 14),
              PrimaryButton(
                  text: 'Añadir al carrito',
                  onTap: () {
                    app.addToCart(currentProduct);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Producto añadido al carrito')));
                  })
            ])));
  }
}
