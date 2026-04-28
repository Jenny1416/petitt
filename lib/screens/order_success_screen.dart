import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/app_state.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderModel order;
  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified, color: Color(0xff078818), size: 95),
                const SizedBox(height: 16),
                const Text(
                  'Pago realizado exitosamente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                ),
                const SizedBox(height: 8),
                Text(
                  'ID pedido: ${order.id}\nTotal: \$${order.total.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  text: 'Ver pedido',
                  onTap: () {
                    final app = context.read<AppState>();
                    app.setHomeTabIndex(3); // Go to Orders tab
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
