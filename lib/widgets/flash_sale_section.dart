import 'package:flutter/material.dart';

/// Widget FlashSaleSection: Muestra una sección de ofertas destacadas con un gradiente premium.
/// Es una técnica de UX para captar la atención del usuario mediante "Scarcity" (escasez).
class FlashSaleSection extends StatelessWidget {
  // Manejo de Datos (List/ArrayList): Recibe una lista dinámica de productos filtrados por descuento.
  final List<dynamic> products;
  final VoidCallback onViewAll;

  const FlashSaleSection({
    super.key,
    required this.products,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    // Adaptabilidad Visual: Si no hay productos en oferta, el widget se oculta para no romper el layout.
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contenedor con gradiente para resaltar la importancia visual (Premium Look)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff123516), Color(0xff1b4d20)], // Verde Bosque (Palette Primary)
            ),
            borderRadius: BorderRadius.circular(20), // Border radius alto (Organic Style)
            boxShadow: [
              BoxShadow(
                color: const Color(0xff123516).withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Super Ofertas',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Venta Flash 50% - 60%',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
              const Spacer(),
              // Retroalimentación al usuario (Feedback): Botón interactivo para ver más
              TextButton(
                onPressed: onViewAll,
                child: const Text(
                  'Ver todo',
                  style: TextStyle(color: Color(0xffD4933E), fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Distribución adaptable usando Row y Expanded para que se ajuste a cualquier pantalla
        Row(
          children: List.generate(products.length, (i) {
            final p = products[i];
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: onViewAll,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Stack: Técnica de diseño para superponer el badge de descuento sobre la imagen
                        AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            child: Stack(
                              children: [
                                Image.network(
                                  p.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffD4933E), // Acento dorado (Premium Accent)
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '-${p.discount}%',
                                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Text(
                            '\$${p.price.toStringAsFixed(0)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff123516),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
