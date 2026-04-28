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

        // 3. Banner Promocional (Ahora se moverá al hacer scroll)
        const PromoBanner(),
        const SizedBox(height: 16),

        // 4. Contador de Items
        Text('${data.length}+ Items',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),

        // 5. Cuadrícula de productos
        data.isEmpty
            ? const SizedBox(
                height: 200,
                child: Center(child: Text('No se encontraron productos')),
              )
            : GridView.builder(
                shrinkWrap: true, // Importante para que funcione dentro de un ListView
                physics: const NeverScrollableScrollPhysics(), // El scroll lo maneja el ListView principal
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
