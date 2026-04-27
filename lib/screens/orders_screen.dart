import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatelessWidget {
  final bool inTab;
  const OrdersScreen({super.key, this.inTab = false});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final body = app.orders.isEmpty
        ? const Center(child: Text('Aún no tienes pedidos registrados'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: app.orders.length,
            itemBuilder: (_, i) {
              final o = app.orders[i];
              return Card(
                  child: ListTile(
                      leading: const Icon(Icons.local_shipping,
                          color: Color(0xff078818)),
                      title: Text('${o.status} - ${o.id}'),
                      subtitle: Text(
                          '${o.date} · ${o.items.length} artículos · \$${o.total.toStringAsFixed(0)}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => OrderDetailScreen(order: o)))));
            });
    return inTab
        ? body
        : Scaffold(
            appBar: AppBar(title: const Text('Historial de pedidos')),
            body: body);
  }
}
