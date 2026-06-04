import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_tag.dart';
import '../../domain/models/product.dart';
import '../../infrastructure/state/controllers/product_controller.dart';
import '../../infrastructure/state/controllers/cart_controller.dart';
import '../routes/app_pages.dart';

/// CAPA DE PRESENTACIÓN - Widget Reutilizable: Tarjeta de Producto
/// Este widget es un componente "tonto" (stateless) que recibe una entidad
/// de dominio [Product] y utiliza controladores de infraestructura para
/// interactuar con el estado global (favoritos, carrito).
class ProductCard extends StatelessWidget {
  final Product p;
  const ProductCard({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    // Localización de controladores mediante inyección de dependencias
    final ProductController productController = Get.find<ProductController>();
    final CartController cartController = Get.find<CartController>();
    
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.productDetail,
        arguments: p,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección superior: Imagen y acciones rápidas
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'product-${p.id}',
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(p.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Botón de Favorito Reactivo
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Obx(() => GestureDetector(
                      onTap: () => productController.toggleFavorite(p),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        child: Icon(
                          productController.isFav(p) ? Icons.favorite : Icons.favorite_border,
                          color: productController.isFav(p) ? Colors.pink : Colors.grey,
                          size: 16,
                        ),
                      ),
                    )),
                  ),
                  if (p.discount > 0)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CustomTag(text: '-${p.discount}%'),
                    ),
                ],
              ),
            ),
            
            // Sección inferior: Información del producto y acción de compra
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xff123516),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${p.rating}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${p.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xff123516),
                        ),
                      ),
                      // Acción rápida para añadir al carrito
                      GestureDetector(
                        onTap: () {
                          cartController.addToCart(p);
                          Get.snackbar(
                            'Carrito',
                            '${p.name} añadido',
                            duration: const Duration(seconds: 1),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xff123516),
                            colorText: Colors.white,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xff123516),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
