import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/logo.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String q = '', cat = 'Todos';
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final pages = [
      _Catalog(
          q: q,
          cat: cat,
          onQ: (v) => setState(() => q = v),
          onCat: (v) => setState(() => cat = v)),
      const _Favorites(),
      const CartScreen(inTab: true),
      const OrdersScreen(inTab: true),
      const ProfileScreen()
    ];
    return Scaffold(
        appBar: AppBar(
            title: const PetitLogo(size: 34),
            centerTitle: false,
            actions: [
              IconButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                  icon: Badge(
                      label: Text('${app.cart.length}'),
                      child: const Icon(Icons.shopping_cart_outlined)))
            ]),
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Inicio'),
            NavigationDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: 'Deseos'),
            NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: 'Carrito'),
            NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'Pedidos'),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Config.')
          ],
        ));
  }
}

class _Catalog extends StatelessWidget {
  final String q, cat;
  final ValueChanged<String> onQ, onCat;
  const _Catalog(
      {required this.q,
      required this.cat,
      required this.onQ,
      required this.onCat});

  Widget _buildFlashSaleSection(BuildContext context, AppState app) {
    final flashProducts =
        app.products.where((p) => p.discount >= 50).take(4).toList();

    if (flashProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera Verde Oscuro
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xff123516),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Super Ofertas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Venta Flash    50% - 60%',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.offer),
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  children: [
                    Text('Ver todo', style: TextStyle(color: Colors.white)),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Fila de 4 productos mini (exactamente 4 en fila)
        Row(
          children: List.generate(flashProducts.length, (i) {
            final p = flashProducts[i];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 0 : 3,
                  right: i == flashProducts.length - 1 ? 0 : 3,
                ),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.offer),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            child: Stack(
                              children: [
                                Image.network(
                                  p.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.pets, size: 16)),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.pink,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text('-${p.discount}%',
                                        style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '\$${p.price.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xff078818)),
                              ),
                            ],
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

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final data = app.search(q, cat);
    final cats = ['Todos', 'Perros', 'Gatos', 'Juguetes', 'Cuidado'];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Buscador
        TextField(
            onChanged: onQ,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Busca cualquier producto...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),

        // 2. Categorías
        SizedBox(
            height: 42,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ChoiceChip(
                    label: Text(cats[i]),
                    selected: cat == cats[i],
                    onSelected: (_) => onCat(cats[i])))),
        const SizedBox(height: 16),

        // 3. Banner Promocional
        const PromoBanner(),
        const SizedBox(height: 16),

        // 3.5 SECCIÓN SUPER OFERTAS (Fila horizontal compacta)
        _buildFlashSaleSection(context, app),
        const SizedBox(height: 16),

        // 4. Contador de Items
        Text('${data.length}+ Items',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),

        // 5. Cuadrícula de productos regular
        data.isEmpty
            ? const SizedBox(
                height: 200,
                child: Center(child: Text('No se encontraron productos')),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .63,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (_, i) => ProductCard(p: data[i])),
      ],
    );
  }
}

class _Favorites extends StatelessWidget {
  const _Favorites();
  @override
  Widget build(BuildContext context) {
    final fav = context.watch<AppState>().favorites;
    return fav.isEmpty
        ? const Center(child: Text('Aún no tienes productos favoritos'))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fav.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .63,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (_, i) => ProductCard(p: fav[i]));
  }
}
