import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/order.dart';

class OrdersScreen extends StatelessWidget {
  final bool inTab;
  final int initialTabIndex;
  const OrdersScreen({super.key, this.inTab = false, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return DefaultTabController(
      length: 3,
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: inTab ? null : const Text('Mis Pedidos'),
          toolbarHeight: inTab ? 0 : null,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Recibidos'),
              Tab(text: 'En Camino'),
              Tab(text: 'Cancelados'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OrderList(orders: app.orders.where((o) => o.status == OrderStatus.delivered).toList()),
            _OrderList(orders: app.orders.where((o) => o.status == OrderStatus.shipping || o.status == OrderStatus.processing).toList()),
            _OrderList(orders: app.orders.where((o) => o.status == OrderStatus.cancelled).toList()),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderModel> orders;
  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(child: Text('No hay pedidos en esta sección'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) => _OrderCard(order: orders[index]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.delivered: return Colors.lightBlue;
      case OrderStatus.shipping:
      case OrderStatus.processing: return Colors.green;
      case OrderStatus.cancelled: return Colors.red.shade700;
    }
  }

  String _getStatusText() {
    switch (order.status) {
      case OrderStatus.delivered: return 'Pedido Entregado';
      case OrderStatus.shipping:
      case OrderStatus.processing: return 'Pedido en Camino';
      case OrderStatus.cancelled: return 'Pedido Cancelado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('ID: ${order.id}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(order.date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.blueGrey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${order.items.length} ${order.items.length == 1 ? 'artículo' : 'artículos'}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Estado: ${_getStatusText()}', style: TextStyle(color: _getStatusColor(), fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('Total: \$${order.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                _actionButton('Pista Pedido', Icons.location_on_outlined, Colors.lightBlue, () => _showTracking(context, order)),
                if (order.status == OrderStatus.delivered) ...[
                  const SizedBox(height: 8),
                  _actionButton('Reseña Pedido', Icons.star_border, Colors.orange, () => _showReviewDialog(context, order)),
                  const SizedBox(height: 8),
                  _actionButton('Devolución Pedido', Icons.keyboard_return, Colors.pink, () {}),
                ],
                if (order.status == OrderStatus.shipping || order.status == OrderStatus.processing) ...[
                  const SizedBox(height: 8),
                  _actionButton('Confirmar Entrega', Icons.check_circle_outline, Colors.green, () => _confirmDelivery(context, app, order)),
                  const SizedBox(height: 8),
                  _actionButton('Cancelar Pedido', Icons.cancel_outlined, Colors.red, () => _confirmCancel(context, app, order)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: color.withOpacity(0.3)), borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            const Spacer(),
            Icon(Icons.chevron_right, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.4, expand: false,
          builder: (_, scrollController) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Calificar Productos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Toca en "Calificar" para dejar tu opinión sobre cada artículo.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Divider(height: 30),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: order.items.length,
                    itemBuilder: (context, i) {
                      final item = order.items[i];
                      final isReviewed = order.reviewedProductIds.contains(item.product.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.product.image, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.pets))),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const Row(children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16), Icon(Icons.star, color: Colors.amber, size: 16),
                                    Icon(Icons.star, color: Colors.amber, size: 16), Icon(Icons.star, color: Colors.amber, size: 16),
                                    Icon(Icons.star_border, color: Colors.amber, size: 16),
                                  ]),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: isReviewed ? null : () {
                                _showProductRatingInput(context, order, item.product);
                              },
                              child: Text(isReviewed ? '¡Calificado!' : 'Calificar', 
                                style: TextStyle(color: isReviewed ? Colors.green : Colors.blue, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProductRatingInput(BuildContext context, OrderModel order, product) {
    double selectedStars = 5;
    final commentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Calificar ${product.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(
                    index < selectedStars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setDialogState(() => selectedStars = index + 1.0),
                )),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: 'Escribe tu opinión (opcional)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                context.read<AppState>().rateProduct(order, product.id, selectedStars, commentController.text);
                Navigator.pop(context); // Cierra dialogo
                Navigator.pop(context); // Cierra bottom sheet para refrescar
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTracking(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              const Text('Seguimiento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('ID: ${order.id}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ]),
            const SizedBox(height: 20),
            ...order.tracking.map((step) => _buildTrackingStep(step)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStep(TrackingStep step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(step.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: step.isCompleted ? Colors.green : Colors.grey, size: 20),
            Container(width: 2, height: 35, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(step.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Spacer(),
                if (step.date.isNotEmpty)
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                    child: Text(step.date, style: const TextStyle(fontSize: 10, color: Colors.green))),
              ]),
              Text(step.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmCancel(BuildContext context, AppState app, OrderModel order) {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const CircleAvatar(backgroundColor: Colors.redAccent, radius: 25, child: Icon(Icons.priority_high, color: Colors.white, size: 30)),
        const SizedBox(height: 16),
        const Text('¿Seguro que desea cancelar el pedido?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('ID: ${order.id}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
      actions: [
        Row(children: [
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context), child: const Text('No', style: TextStyle(color: Colors.white)))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
            onPressed: () { app.cancelOrder(order); Navigator.pop(context); }, child: const Text('Sí, Cancelar', style: TextStyle(color: Colors.white)))),
        ])
      ],
    ));
  }

  void _confirmDelivery(BuildContext context, AppState app, OrderModel order) {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const CircleAvatar(backgroundColor: Colors.green, radius: 25, child: Icon(Icons.check, color: Colors.white, size: 30)),
        const SizedBox(height: 16),
        const Text('¿Ya recibiste tu pedido?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Al confirmar, el pedido pasará a la sección de "Recibidos" y podrás calificar los productos.', 
          textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
      actions: [
        Row(children: [
          Expanded(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Aún no'))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () { app.confirmDelivery(order); Navigator.pop(context); }, 
            child: const Text('Sí, Recibido', style: TextStyle(color: Colors.white)))),
        ])
      ],
    ));
  }
}
