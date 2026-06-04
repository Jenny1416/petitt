import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/models/order.dart';
import '../../state/controllers/product_controller.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderModel? order;
  const OrderSuccessScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final OrderModel finalOrder = order ?? Get.arguments as OrderModel;
    return Scaffold(
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
                  'ID pedido: ${finalOrder.id}\nTotal: \$${finalOrder.total.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  text: 'Ver pedido',
                  onTap: () {
                    final productController = Get.find<ProductController>();
                    productController.setHomeTabIndex(3); // Go to Orders tab
                    Get.offAll(() => const HomeScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }
}
