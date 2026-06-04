import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/models/product.dart';
import '../../state/controllers/product_controller.dart';
import '../../state/controllers/cart_controller.dart';
import '../widgets/product_attribute.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/primary_button.dart';
import '../routes/app_pages.dart';

/// CAPA DE PRESENTACIÓN - Pantalla de Detalle de Producto
/// Esta pantalla muestra la información extendida de un producto.
/// Utiliza controladores GetX para gestionar favoritos y el carrito,
/// demostrando la integración entre UI y lógica de infraestructura.
class ProductDetailScreen extends StatefulWidget {
  final Product? product;
  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Inyección de dependencias mediante GetX
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  
  late Product currentProduct;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    // Recuperación del producto desde argumentos o parámetro directo
    currentProduct = widget.product ?? Get.arguments as Product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Cabecera colapsable con imagen del producto
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
                  onPressed: () => Get.back(),
                ),
                actions: [
                  // Reactividad: Botón de favoritos vinculado al estado global
                  Obx(() => IconButton(
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        productController.isFav(currentProduct) ? Icons.favorite : Icons.favorite_border,
                        color: Colors.pink,
                        size: 20,
                      ),
                    ),
                    onPressed: () => productController.toggleFavorite(currentProduct),
                  )),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product-${currentProduct.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          currentProduct.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.pets, size: 100, color: Colors.grey),
                          ),
                        ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xff123516).withValues(alpha: 0.1),
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
                              // Observación reactiva de cambios en rating/reseñas
                              Obx(() {
                                final p = productController.products.firstWhere((p) => p.id == currentProduct.id, orElse: () => currentProduct);
                                return Row(
                                  children: [
                                    Text(p.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(' (${p.reviews.length} reseñas)', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                  ],
                                );
                              }),
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
                          // Selector de cantidad (Estado Local de la pantalla)
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

                      const Text('Sobre este producto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff123516))),
                      const SizedBox(height: 12),
                      Text(
                        currentProduct.description,
                        style: TextStyle(color: Colors.grey.shade700, height: 1.6),
                      ),
                      
                      const SizedBox(height: 24),

                      const Row(
                        children: [
                          ProductAttribute(icon: Icons.pets, label: 'Para', value: 'Perros'), 
                          ProductAttribute(icon: Icons.inventory_2_outlined, label: 'Stock', value: 'Disponible'),
                          ProductAttribute(icon: Icons.local_shipping_outlined, label: 'Envío', value: 'Gratis >\$50k'),
                        ],
                      ),

                      const SizedBox(height: 32),

                      InkWell(
                        onTap: () => Get.toNamed(AppRoutes.reviews, arguments: currentProduct),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Reseñas de clientes', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Mira lo que dicen otros pet lovers', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xff123516)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Barra de acción fija en la parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
                ],
              ),
              child: PrimaryButton(
                text: 'Añadir al carrito • \$${(currentProduct.price * quantity).toStringAsFixed(0)}',
                onTap: () {
                  // Acción de orquestación delegada al controlador
                  for (int i = 0; i < quantity; i++) {
                    cartController.addToCart(currentProduct);
                  }
                  Get.snackbar(
                    'Carrito',
                    '¡$quantity ${currentProduct.name} añadidos!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xff123516),
                    colorText: Colors.white,
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
