import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';

class FlashSaleSection extends StatelessWidget {
  final List<dynamic> products;
  final VoidCallback onViewAll;

  const FlashSaleSection({
    super.key,
    required this.products,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff123516), Color(0xff1b4d20)],
            ),
            borderRadius: BorderRadius.circular(20),
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
                                      color: const Color(0xffD4933E),
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
