import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../widgets/product_attribute.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/primary_button.dart';
import 'reviews_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final currentProduct = app.products.firstWhere(
      (p) => p.id == widget.product.id, 
      orElse: () => widget.product
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header con imagen Hero
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: const Color(0xff123516),
                elevation: 0,
                leading: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xff123516)),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        app.isFav(currentProduct) ? Icons.favorite : Icons.favorite_border,
                        color: Colors.pink,
                        size: 20,
                      ),
                    ),
                    onPressed: () => app.toggleFavorite(currentProduct),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product-${currentProduct.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          currentProduct.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.pets, size: 100, color: Colors.grey),
                          ),
                        ),
                        // Gradiente para que se vea mejor el contenido
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [Colors.black26, Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags y Categoría
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xff123516).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              currentProduct.type.toUpperCase(),
                              style: const TextStyle(color: Color(0xff123516), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(currentProduct.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(' (${currentProduct.reviews.length} reseñas)', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        currentProduct.name,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xff123516)),
                      ),
                      Text(
                        'Por ${currentProduct.brand}',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                      ),
                      
                      const SizedBox(height: 24),

                      // Precio y Cantidad
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (currentProduct.discount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(6)),
                                  child: Text('-${currentProduct.discount}% OFF', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('\$${currentProduct.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xff123516))),
                                  const SizedBox(width: 8),
                                  if (currentProduct.discount > 0)
                                    Text('\$${currentProduct.oldPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Selector de cantidad
                          QuantitySelector(
                            quantity: quantity,
                            onDecrement: () => setState(() => quantity = (quantity > 1) ? quantity - 1 : 1),
                            onIncrement: () => setState(() => quantity = (quantity < currentProduct.stock) ? quantity + 1 : quantity),
                            height: 44,
                            iconSize: 20,
                          ),
                        ],
                      ),

                      const Divider(height: 48),

                      // Descripción
                      const Text('Sobre este producto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff123516))),
                      const SizedBox(height: 12),
                      Text(
                        currentProduct.description,
                        style: TextStyle(color: Colors.grey.shade700, height: 1.6),
                      ),
                      
                      const SizedBox(height: 24),

                      // Atributos rápidos
                      Row(
                        children: [
                          ProductAttribute(icon: Icons.pets, label: 'Para', value: currentProduct.category),
                          ProductAttribute(icon: Icons.inventory_2_outlined, label: 'Stock', value: '${currentProduct.stock} uds'),
                          ProductAttribute(icon: Icons.local_shipping_outlined, label: 'Envío', value: 'Gratis >\$50k'),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Reseñas
                      InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewsScreen(product: currentProduct))),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Reseñas de clientes', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Mira lo que dicen otros pet lovers', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xff123516)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 120), // Espacio para el botón inferior
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Botón inferior flotante
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
                ],
              ),
              child: PrimaryButton(
                text: 'Añadir al carrito • \$${(currentProduct.price * quantity).toStringAsFixed(0)}',
                onTap: () {
                  for (int i = 0; i < quantity; i++) {
                    app.addToCart(currentProduct);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('¡$quantity ${currentProduct.name} añadidos!'),
                      backgroundColor: const Color(0xff123516),
                      behavior: SnackBarBehavior.floating,
                    )
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


}
