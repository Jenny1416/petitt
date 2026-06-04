import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/models/order.dart';
import '../../state/controllers/order_controller.dart';
import '../../state/controllers/product_controller.dart';
import '../../state/controllers/auth_controller.dart';
import '../widgets/empty_state_widget.dart';

/// CAPA DE PRESENTACIÓN - Pantalla de Historial de Pedidos
/// Gestiona la visualización de pedidos y la navegación entre estados.
class OrdersScreen extends StatefulWidget {
  final bool inTab;
  final int initialTabIndex;
  const OrdersScreen({super.key, this.inTab = false, this.initialTabIndex = 0});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, 
      vsync: this, 
      initialIndex: widget.initialTabIndex
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.inTab ? null : const Text('Mis Pedidos'),
        toolbarHeight: widget.inTab ? 0 : null,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Recibidos'),
            Tab(text: 'En Camino'),
            Tab(text: 'Cancelados'),
          ],
        ),
      ),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Filtramos las listas en tiempo real
        final delivered = orderController.orders.where((o) => o.status == OrderStatus.delivered).toList();
        final shipping = orderController.orders.where((o) => o.status == OrderStatus.shipping || o.status == OrderStatus.processing).toList();
        final cancelled = orderController.orders.where((o) => o.status == OrderStatus.cancelled).toList();

        return TabBarView(
          controller: _tabController,
          children: [
            _OrderList(orders: delivered, tabController: _tabController),
            _OrderList(orders: shipping, tabController: _tabController),
            _OrderList(orders: cancelled, tabController: _tabController),
          ],
        );
      }),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderModel> orders;
  final TabController tabController;
  const _OrderList({required this.orders, required this.tabController});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        title: 'Sin pedidos',
        description: 'Aún no tienes pedidos en esta sección.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) => _OrderCard(
        order: orders[index], 
        tabController: tabController
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final TabController tabController;
  const _OrderCard({required this.order, required this.tabController});

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

  Widget _buildProductImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 60, height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset('assets/images/1.png', width: 60, height: 60, fit: BoxFit.cover),
      );
    } else {
      return Image.asset(
        imagePath,
        width: 60, height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: Colors.blueGrey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: order.items.isNotEmpty 
                      ? _buildProductImage(order.items[0].product.image)
                      : const Icon(Icons.shopping_bag_outlined, color: Colors.blueGrey),
                  ),
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
                ],
                if (order.status == OrderStatus.shipping || order.status == OrderStatus.processing) ...[
                  const SizedBox(height: 8),
                  _actionButton('Confirmar Entrega', Icons.check_circle_outline, Colors.green, () => _confirmDelivery(context, orderController, order)),
                  const SizedBox(height: 8),
                  _actionButton('Cancelar Pedido', Icons.cancel_outlined, Colors.red, () => _confirmCancel(context, orderController, order)),
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
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
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

  void _confirmCancel(BuildContext context, OrderController controller, OrderModel order) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: const Column(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(backgroundColor: Colors.redAccent, radius: 25, child: Icon(Icons.priority_high, color: Colors.white, size: 30)),
        SizedBox(height: 16),
        Text('¿Seguro que desea cancelar el pedido?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Se eliminará permanentemente de tu historial.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
      actions: [
        Row(children: [
          Expanded(child: TextButton(onPressed: () => Get.back(), child: const Text('No, volver'))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () { 
              controller.cancelOrder(order); 
              Get.back(); 
            }, 
            child: const Text('Sí, Eliminar', style: TextStyle(color: Colors.white)))),
        ])
      ],
    ));
  }

  void _confirmDelivery(BuildContext context, OrderController controller, OrderModel order) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: const Column(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(backgroundColor: Colors.green, radius: 25, child: Icon(Icons.check, color: Colors.white, size: 30)),
        SizedBox(height: 16),
        Text('¿Ya recibiste tu pedido?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Al confirmar, el pedido pasará a la sección de "Recibidos" y podrás calificar los productos.', 
          textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            Expanded(child: TextButton(onPressed: () => Get.back(), child: const Text('Aún no'))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () { 
                controller.confirmDelivery(order); 
                Get.back();
                // Saltamos a la pestaña de Recibidos (Index 0)
                tabController.animateTo(0);
              }, 
              child: const Text('Sí, Recibido'))),
          ]),
        )
      ],
    ));
  }

  void _showReviewDialog(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.4, expand: false,
        builder: (_, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Calificar Productos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Tu opinión ayuda a otros dueños de mascotas.', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const Divider(height: 30),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: order.items.length,
                  itemBuilder: (context, i) {
                    final item = order.items[i];
                    return Obx(() {
                      final isReviewed = order.reviewedProductIds.contains(item.product.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _buildProductImage(item.product.image),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Row(children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 16))),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: isReviewed ? null : () => _showProductRatingInput(context, order, item.product),
                              child: Text(isReviewed ? '¡Listo!' : 'Calificar', 
                                style: TextStyle(color: isReviewed ? Colors.grey : Colors.blue, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
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
                  icon: Icon(index < selectedStars ? Icons.star : Icons.star_border, color: Colors.amber),
                  onPressed: () => setDialogState(() => selectedStars = index + 1.0),
                )),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: 'Comentario (opcional)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final productController = Get.find<ProductController>();
                final authController = Get.find<AuthController>();
                final orderController = Get.find<OrderController>();
                
                productController.addReview(
                  product.id, 
                  selectedStars, 
                  commentController.text, 
                  authController.currentUser?.name ?? 'Usuario'
                );
                orderController.markAsReviewed(order, product.id);
                Get.back();
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
                  Text(step.date, style: const TextStyle(fontSize: 10, color: Colors.green)),
              ]),
              Text(step.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
