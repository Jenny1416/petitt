import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../state/controllers/cart_controller.dart';
import '../../state/controllers/product_controller.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/primary_button.dart';
import '../routes/app_pages.dart';

/// CAPA DE PRESENTACIÓN - Pantalla de Carrito
/// Muestra los productos seleccionados por el usuario y permite gestionar
/// cantidades antes de proceder al pago.
/// Consume el [CartController] para reflejar el estado actual del carrito
/// y los cálculos de precios/ahorros.
/// CartScreen - Capa de Presentación
/// 
/// Pantalla reactiva que gestiona el carrito de compras.
/// Consume el [CartController] para reflejar el estado global de los productos
/// seleccionados y utiliza el [ProductController] para la navegación.
class CartScreen extends StatelessWidget {
  final bool inTab;
  const CartScreen({super.key, this.inTab = false});

  @override
  Widget build(BuildContext context) {
    /// Localización de controladores de la capa de Infraestructura/Estado
    final CartController cartController = Get.find<CartController>();
    final ProductController productController = Get.find<ProductController>();

    return Obx(() {
      /// Estado Vacío: Manejado de forma reactiva gracias a GetX
      if (cartController.cartItems.isEmpty) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: inTab ? null : AppBar(title: const Text('Mi Carrito'), elevation: 0, backgroundColor: Colors.white),
          body: EmptyStateWidget(
            icon: Icons.shopping_basket_outlined,
            title: 'Tu carrito está vacío',
            description: 'Parece que aún no has añadido nada. ¡Tus mascotas están esperando algo especial!',
            buttonText: 'Explorar productos',
            onButtonTap: () => productController.setHomeTabIndex(0),
            iconColor: Colors.green.shade200,
            iconBackgroundColor: Colors.green.shade50,
          ),
        );
      }

      // Lógica de cálculo delegada o computada localmente para la UI
      double totalSavings = cartController.cartItems.fold(0, (sum, item) {
        double diff = item.product.oldPrice - item.product.price;
        return sum + (diff > 0 ? diff * item.quantity : 0);
      });

      int totalItems = cartController.cartItems.fold(0, (sum, item) => sum + item.quantity);

      final body = Container(
        color: Colors.grey.shade50,
        child: Column(
          children: [
            _buildShippingBanner(cartController),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: cartController.cartItems.length,
                itemBuilder: (_, i) {
                  final item = cartController.cartItems[i];
                  return _buildCartItem(cartController, item);
                },
              ),
            ),
            
            _buildBottomSummary(context, cartController, totalSavings, totalItems),
          ],
        ),
      );

      return inTab
          ? body
          : Scaffold(
              backgroundColor: Colors.grey.shade50,
              appBar: AppBar(
                title: const Text('Mi Carrito', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff123516))),
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
              ),
              body: body,
            );
    });
  }

  /// Banner dinámico que informa sobre el progreso para envío gratuito
  Widget _buildShippingBanner(CartController cartController) {
    const double limit = 50000;
    final double remaining = limit - cartController.subtotal;
    final bool free = remaining <= 0;
    final double progress = (cartController.subtotal / limit).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Icon(free ? Icons.check_circle : Icons.local_shipping, 
                   color: free ? Colors.green : Colors.orange, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  free ? '¡Tienes envío GRATIS!' : 'Te faltan \$${remaining.toStringAsFixed(0)} para el envío gratis',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: free ? Colors.green.shade700 : Colors.orange.shade900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(free ? Colors.green : Colors.orange),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  /// Representación visual de un producto en el carrito
  Widget _buildCartItem(CartController cartController, dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset( // Corregido de .network a .asset para consistencia local
                    item.product.image,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 85, height: 85, color: Colors.grey.shade100, child: const Icon(Icons.pets)),
                  ),
                ),
                if (item.product.discount > 0)
                  Positioned(
                    top: 0, left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(10))),
                      child: Text('-${item.product.discount}%', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(item.product.brand, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('\$${item.product.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff078818), fontSize: 16)),
                      if (item.product.oldPrice > item.product.price) ...[
                        const SizedBox(width: 6),
                        Text('\$${item.product.oldPrice.toStringAsFixed(0)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => cartController.removeFromCart(item.product),
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 12),
                QuantitySelector(
                  quantity: item.quantity,
                  onDecrement: () => cartController.changeQty(item.product, -1),
                  onIncrement: () => cartController.changeQty(item.product, 1),
                  height: 32,
                  iconSize: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Resumen de costos y botón de acción principal
  Widget _buildBottomSummary(BuildContext context, CartController cartController, double savings, int items) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: inTab,
        child: Column(
          children: [
            _row('Productos ($items)', cartController.subtotal),
            if (savings > 0) _row('Tus ahorros', savings, isSavings: true),
            _row('Costo de envío', cartController.shipping, isFree: cartController.shipping == 0),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total estimado', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('Incluye impuestos', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                Text('\$${cartController.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff123516))),
              ],
            ),
            const SizedBox(height: 20),
            /// Transición a la siguiente etapa del flujo de compra (Checkout)
            PrimaryButton(
              text: 'Continuar al pago',
              onTap: () => Get.toNamed(AppRoutes.checkout),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double value, {bool isSavings = false, bool isFree = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isSavings ? Colors.pink : Colors.grey.shade700, fontWeight: isSavings ? FontWeight.bold : FontWeight.normal)),
          if (isFree)
            const Text('GRATIS', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
          else
            Text('${isSavings ? "- " : ""}\$${value.toStringAsFixed(0)}', 
              style: TextStyle(color: isSavings ? Colors.pink : Colors.black87, fontWeight: isSavings ? FontWeight.bold : FontWeight.w600)
            ),
        ],
      ),
    );
  }
}
