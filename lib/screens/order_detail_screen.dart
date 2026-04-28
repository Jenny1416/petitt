import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    const sliderValue = .35;
    return Scaffold(
        appBar: AppBar(title: Text('Pedido ${order.id}')),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text('${order.status}\n${order.date}',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 12),
              const Text('Estado Pedido',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Slider(value: sliderValue, onChanged: null),
              const Text('Packed'),
              const Text(
                  'Su paquete está alistándose y será entregado a nuestro socio de entrega.'),
              const Divider(height: 30),
              const Text('Artículos del pedido',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ...order.items.map((c) => ListTile(
                  leading: Image.network(c.product.image,
                      width: 55,
                      errorBuilder: (_, __, ___) => const Icon(Icons.pets)),
                  title: Text(c.product.name),
                  subtitle: Text('Cantidad: ${c.quantity}'),
                  trailing: Text('\$${c.total.toStringAsFixed(0)}'))),
              const Divider(),
              Text('Dirección: ${order.address}'),
              Text('Pago: ${order.payment}'),
              const SizedBox(height: 10),
              Text('Total: \$${order.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18))
            ])));
  }
}
