import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/primary_button.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final bool inTab;
  const CartScreen({super.key, this.inTab = false});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    if (app.cart.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: inTab ? null : AppBar(title: const Text('Mi Carrito'), elevation: 0, backgroundColor: Colors.white),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.green.shade200),
              ),
              const SizedBox(height: 24),
              const Text('Tu carrito está vacío', 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff123516))
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text('Parece que aún no has añadido nada. ¡Tus mascotas están esperando algo especial!', 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15)
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 220,
                child: PrimaryButton(
                  text: 'Explorar productos',
                  onTap: () => app.setHomeTabIndex(0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Calcular ahorro total basado en oldPrice
    double totalSavings = app.cart.fold(0, (sum, item) {
      double diff = item.product.oldPrice - item.product.price;
      return sum + (diff > 0 ? diff * item.quantity : 0);
    });

    int totalItems = app.cart.fold(0, (sum, item) => sum + item.quantity);

    final body = Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          // Banner de Envío Gratis
          _buildShippingBanner(app),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: app.cart.length,
              itemBuilder: (_, i) {
                final item = app.cart[i];
                return _buildCartItem(app, item);
              },
            ),
          ),
          
          // Panel de resumen inferior
          _buildBottomSummary(context, app, totalSavings, totalItems),
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
  }

  Widget _buildShippingBanner(AppState app) {
    const double limit = 50000;
    final double remaining = limit - app.subtotal;
    final bool free = remaining <= 0;
    final double progress = (app.subtotal / limit).clamp(0.0, 1.0);

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

  Widget _buildCartItem(AppState app, dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen con badge de descuento si aplica
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
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
            // Detalles
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
            // Controles
            Column(
              children: [
                IconButton(
                  onPressed: () => app.removeFromCart(item.product),
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      _qtyBtn(Icons.remove, () => app.changeQty(item.product, -1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      _qtyBtn(Icons.add, () => app.changeQty(item.product, 1)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => IconButton(
    onPressed: onTap,
    icon: Icon(icon, size: 16),
    constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
    padding: EdgeInsets.zero,
  );

  Widget _buildBottomSummary(BuildContext context, AppState app, double savings, int items) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: inTab,
        child: Column(
          children: [
            _row('Productos ($items)', app.subtotal),
            if (savings > 0) _row('Tus ahorros', savings, isSavings: true),
            _row('Costo de envío', app.shipping, isFree: app.shipping == 0),
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
                Text('\$${app.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff123516))),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Continuar al pago',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
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
