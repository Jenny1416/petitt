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
    final body = app.cart.isEmpty
        ? const Center(child: Text('Tu carrito está vacío'))
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: app.cart.length,
                  itemBuilder: (_, i) {
                    final c = app.cart[i];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          c.product.image,
                          width: 55,
                          errorBuilder: (_, __, ___) => const Icon(Icons.pets),
                        ),
                        title: Text(c.product.name, maxLines: 2),
                        subtitle:
                            Text('\$${c.product.price.toStringAsFixed(0)}'),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => app.changeQty(c.product, -1),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${c.quantity}'),
                            IconButton(
                              onPressed: () => app.changeQty(c.product, 1),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                            IconButton(
                              onPressed: () => app.removeFromCart(c.product),
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _row('Subtotal', app.subtotal),
                    _row('Envío', app.shipping),
                    const Divider(),
                    _row('Total', app.total, bold: true),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      text: 'Pagar',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
    return inTab
        ? body
        : Scaffold(
            appBar: AppBar(title: const Text('Carrito de compras')),
            body: body,
          );
  }

  Widget _row(String t, double v, {bool bold = false}) => Row(
        children: [
          Text(t, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
          const Spacer(),
          Text('\$${v.toStringAsFixed(0)}',
              style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
        ],
      );
}
