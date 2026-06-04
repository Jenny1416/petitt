import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/models/order.dart';

/// OrderDetailScreen - Capa de Presentación
/// 
/// Muestra el desglose detallado de un pedido específico, incluyendo
/// su estado actual, seguimiento, artículos y datos de envío.
class OrderDetailScreen extends StatelessWidget {
  final OrderModel? order;
  const OrderDetailScreen({super.key, this.order});
  
  @override
  Widget build(BuildContext context) {
    /// Obtención del pedido desde los argumentos de navegación si no se pasa directamente
    final OrderModel finalOrder = order ?? Get.arguments as OrderModel;
    const sliderValue = .35;
    
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text('Pedido ${finalOrder.id}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildStatusHeader(finalOrder),
              const SizedBox(height: 24),
              const Text('Seguimiento del Pedido',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff123516))),
              const Slider(value: sliderValue, onChanged: null),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('En preparación', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Su paquete está alistándose y será entregado a nuestro socio de entrega.',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              const Divider(height: 40),
              const Text('Artículos del pedido',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff123516))),
              const SizedBox(height: 12),
              ...finalOrder.items.map((c) => _buildProductItem(c)),
              const Divider(height: 40),
              _buildDeliveryInfo(finalOrder),
            ])));
  }

  Widget _buildStatusHeader(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xff123516).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xff123516).withValues(alpha: 0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.status.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff123516))),
              Text(order.date, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset( // Corregido de .network a .asset
                c.product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: Colors.grey)),
          ),
          title: Text(c.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text('Cantidad: ${c.quantity}', style: const TextStyle(fontSize: 12)),
          trailing: Text('\$${c.total.toStringAsFixed(0)}', 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff123516)))),
    );
  }

  Widget _buildDeliveryInfo(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _infoRow(Icons.location_on_outlined, 'Dirección', order.address),
          const Divider(height: 30),
          _infoRow(Icons.payment_outlined, 'Método de pago', order.payment),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pagado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('\$${order.total.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xff123516)))
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

