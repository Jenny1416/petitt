import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
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
      const _OrdersTabWrapper(),
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
        body: IndexedStack(index: app.homeTabIndex, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: app.homeTabIndex,
          onDestinationSelected: (i) => app.setHomeTabIndex(i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Deseos'),
            NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Carrito'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Pedidos'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Config.')
          ],
        ));
  }
}

class _OrdersTabWrapper extends StatelessWidget {
  const _OrdersTabWrapper();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    // We want "En Camino" if there's a very recent order, otherwise default to index 0
    bool hasRecentOrder = app.orders.isNotEmpty && 
        (app.orders.first.status == OrderStatus.processing || app.orders.first.status == OrderStatus.shipping);
    
    return OrdersScreen(inTab: true, initialTabIndex: hasRecentOrder ? 1 : 0);
  }
}

class _Catalog extends StatelessWidget {
  final String q, cat;
  final ValueChanged<String> onQ, onCat;
  const _Catalog({required this.q, required this.cat, required this.onQ, required this.onCat});

  // 1. Widget de Categorías de Animales (Círculos)
  Widget _buildAnimalCircles(BuildContext context) {
    const animals = [
      {'n': 'Todos', 'i': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=100'},
      {'n': 'Pájaros', 'i': 'https://images.unsplash.com/photo-1522926193341-e9fed196d4ad?w=100'},
      {'n': 'Perros', 'i': 'https://images.unsplash.com/photo-1517849845537-4d257902454a?w=100'},
      {'n': 'Gatos', 'i': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=100'},
      {'n': 'Pescados', 'i': 'https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?w=100'},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: animals.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.categoryResult, arguments: animals[i]['n']),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: NetworkImage(animals[i]['i']!),
                ),
                const SizedBox(height: 4),
                Text(animals[i]['n']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }

  // 2. Widget de Super Ofertas
  Widget _buildFlashSaleSection(BuildContext context, AppState app) {
    final flashProducts = app.products.where((p) => p.discount >= 50).take(4).toList();
    if (flashProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: const Color(0xff123516), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Super Ofertas', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Venta Flash 50% - 60%', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.offer),
                child: const Text('Ver todo', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(flashProducts.length, (i) {
            final p = flashProducts[i];
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.offer),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                    child: Column(
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
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade100,
                                    child: const Center(child: Icon(Icons.pets, size: 20, color: Colors.grey)),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                          child: Text(
                            '\$${p.price.toStringAsFixed(0)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff078818),
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

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final data = app.search(q, cat);
    const filterCats = ['Todos', 'Perros', 'Gatos', 'Juguetes', 'Cuidado'];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // BUSCADOR
        TextField(
            onChanged: onQ,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Busca cualquier producto...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 16),

        // CATEGORÍAS ANIMALES (CIRCULOS) - Nueva ubicación
        _buildAnimalCircles(context),
        const SizedBox(height: 16),

        // BANNER
        const PromoBanner(),
        const SizedBox(height: 16),

        // SUPER OFERTAS
        _buildFlashSaleSection(context, app),
        const SizedBox(height: 20),

        // FILTROS (CHIPS) - Reubicados arriba del total de items
        const Text('Filtrar por tipo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        SizedBox(
            height: 34,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filterCats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ChoiceChip(
                    labelStyle: const TextStyle(fontSize: 11),
                    padding: EdgeInsets.zero,
                    label: Text(filterCats[i]),
                    selected: cat == filterCats[i],
                    onSelected: (_) => onCat(filterCats[i])))),
        const SizedBox(height: 16),

        // CONTADOR Y GRILLA
        Text('${data.length}+ Items', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        data.isEmpty
            ? const Center(child: Text('No se encontraron productos'))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .63, crossAxisSpacing: 10, mainAxisSpacing: 10),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .63, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemBuilder: (_, i) => ProductCard(p: fav[i]));
  }
}
