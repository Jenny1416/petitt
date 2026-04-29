import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_tag.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';

class ProductCard extends StatelessWidget {
  final Product p;
  const ProductCard({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.productDetail,
        arguments: p,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con Hero y botón de favorito
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
                          image: NetworkImage(p.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => app.toggleFavorite(p),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: Icon(
                          app.isFav(p) ? Icons.favorite : Icons.favorite_border,
                          color: app.isFav(p) ? Colors.pink : Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
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
            
            // Detalles del producto
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
                      GestureDetector(
                        onTap: () {
                          app.addToCart(p);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${p.name} añadido'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
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
