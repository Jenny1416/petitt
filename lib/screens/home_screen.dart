import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/animal_categories.dart';
import '../widgets/flash_sale_section.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/category_chip_list.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/section_header.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/logo.dart';
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
        extendBody: true,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: app.homeTabIndex,
          onTap: (i) => app.setHomeTabIndex(i),
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


  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final data = app.search(q, cat);
    const filterCats = ['Todos', 'Alimento', 'Accesorio', 'Juguete', 'Cuidado'];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // BUSCADOR
        CustomTextField(
          onChanged: onQ,
          hintText: 'Busca productos para tu mascota...',
          prefixIcon: Icons.search_rounded,
        ),
        const SizedBox(height: 24),

        // CATEGORÍAS ANIMALES (CIRCULOS)
        const SectionHeader(title: 'Nuestras Mascotas'),
        const SizedBox(height: 12),
        const AnimalCategories(),
        const SizedBox(height: 24),

        // BANNER
        const PromoBanner(),
        const SizedBox(height: 24),

        // SUPER OFERTAS
        FlashSaleSection(
          products: app.products.where((p) => p.discount >= 50).take(4).toList(),
          onViewAll: () => Navigator.pushNamed(context, AppRoutes.offer),
        ),
        const SizedBox(height: 24),

        // FILTROS (CHIPS)
        const SectionHeader(title: 'Explorar por categoría'),
        const SizedBox(height: 12),
        CategoryChipList(
          categories: filterCats,
          selectedCategory: cat,
          onSelected: onCat,
        ),
        const SizedBox(height: 24),

        // CONTADOR Y GRILLA
        SectionHeader(
          title: '${data.length}+ Productos',
          actionText: 'Filtrar',
          onActionTap: () {},
        ),
        const SizedBox(height: 12),
        data.isEmpty
            ? const Center(child: Text('No se encontraron productos'))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  childAspectRatio: .63, 
                  crossAxisSpacing: 16, 
                  mainAxisSpacing: 16
                ),
                itemBuilder: (_, i) => ProductCard(p: data[i])),
      ],
    );
  }
}

class _Favorites extends StatelessWidget {
  const _Favorites();
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final fav = app.favorites;

    if (fav.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.favorite_border_rounded,
        title: 'Tu lista está vacía',
        description: 'Guarda los productos que más te gusten aquí para verlos más tarde.',
        buttonText: 'Explorar tienda',
        onButtonTap: () => app.setHomeTabIndex(0),
        iconColor: Colors.pink.shade200,
        iconBackgroundColor: Colors.pink.shade50,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.pink, size: 24),
              const SizedBox(width: 10),
              Text('Tus favoritos (${fav.length})', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff123516))),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fav.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              childAspectRatio: .63, 
              crossAxisSpacing: 12, 
              mainAxisSpacing: 12
            ),
            itemBuilder: (_, i) => ProductCard(p: fav[i]),
          ),
        ),
      ],
    );
  }
}
