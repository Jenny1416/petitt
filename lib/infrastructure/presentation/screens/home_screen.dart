import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/models/order.dart';
import '../../state/controllers/product_controller.dart';
import '../../state/controllers/cart_controller.dart';
import '../../state/controllers/order_controller.dart';
import '../routes/app_pages.dart';
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

/// CAPA DE PRESENTACIÓN - Pantalla Principal (Dashboard)
/// Esta pantalla actúa como el contenedor principal de la aplicación,
/// utilizando un [IndexedStack] para gestionar la navegación entre pestañas
/// de manera reactiva mediante GetX.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Inyección de controladores de la capa de Infraestructura
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  
  // Estado local para filtros simples que no requieren persistencia global
  String q = '', cat = 'Todos';

  @override
  Widget build(BuildContext context) {
    // Definición de las páginas principales asociadas a la navegación inferior
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
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                  // Reactividad: Se actualiza automáticamente cuando cambia el carrito
                  icon: Obx(() => Badge(
                      label: Text('${cartController.cartItems.length}'),
                      child: const Icon(Icons.shopping_cart_outlined))))
            ]),
        // Uso de Obx para reaccionar al cambio de índice en el controlador
        body: Obx(() => IndexedStack(index: productController.homeTabIndex.value, children: pages)),
        extendBody: true,
        bottomNavigationBar: Obx(() => CustomBottomNavBar(
          currentIndex: productController.homeTabIndex.value,
          onTap: (i) => productController.setHomeTabIndex(i),
        )));
  }
}

/// Envoltorio para la pestaña de órdenes que inyecta lógica de navegación inicial
class _OrdersTabWrapper extends StatelessWidget {
  const _OrdersTabWrapper();

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    // Lógica para decidir qué pestaña mostrar por defecto en la sección de pedidos
    bool hasRecentOrder = orderController.orders.isNotEmpty && 
        (orderController.orders.first.status == OrderStatus.processing || orderController.orders.first.status == OrderStatus.shipping);
    
    return OrdersScreen(inTab: true, initialTabIndex: hasRecentOrder ? 1 : 0);
  }
}

/// Componente de Catálogo: Renderiza la lista de productos filtrable
class _Catalog extends StatelessWidget {
  final String q, cat;
  final ValueChanged<String> onQ, onCat;
  const _Catalog({required this.q, required this.cat, required this.onQ, required this.onCat});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    const filterCats = ['Todos', 'Alimento', 'Accesorio', 'Juguete', 'Cuidado'];

    return Obx(() {
      // Aplicación de filtros mediante el controlador
      final data = productController.search(q, cat);
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          CustomTextField(
            onChanged: onQ,
            hintText: 'Busca productos para tu mascota...',
            prefixIcon: Icons.search_rounded,
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Nuestras Mascotas'),
          const SizedBox(height: 12),
          const AnimalCategories(),
          const SizedBox(height: 24),
          const PromoBanner(),
          const SizedBox(height: 24),
          FlashSaleSection(
            products: productController.products.where((p) => p.discount >= 50).take(4).toList(),
            onViewAll: () => Get.toNamed(AppRoutes.offer),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Explorar por categoría'),
          const SizedBox(height: 12),
          CategoryChipList(
            categories: filterCats,
            selectedCategory: cat,
            onSelected: onCat,
          ),
          const SizedBox(height: 24),
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
    });
  }
}

/// Componente de Favoritos: Muestra productos marcados por el usuario
class _Favorites extends StatelessWidget {
  const _Favorites();
  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return Obx(() {
      // Filtrado reactivo de favoritos basado en el estado global
      final fav = productController.products.where((p) => productController.favoriteIds.contains(p.id)).toList();

      if (fav.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.favorite_border_rounded,
          title: 'Tu lista está vacía',
          description: 'Guarda los productos que más te gusten aquí para verlos más tarde.',
          buttonText: 'Explorar tienda',
          onButtonTap: () => productController.setHomeTabIndex(0),
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
    });
  }
}
