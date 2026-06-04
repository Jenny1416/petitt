import '../../../domain/models/order.dart';
import '../../../domain/ports/order_repository.dart';

class InMemoryOrderAdapter implements OrderRepository {
  final List<OrderModel> _orders = [];

  @override
  Future<List<OrderModel>> getOrders() async {
    return _orders;
  }

  @override
  Future<String> createOrder(OrderModel order) async {
    _orders.insert(0, order);
    return order.id;
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final index = _orders.indexWhere((o) => (o.supabaseId ?? o.id) == orderId);
    if (index != -1) {
      _orders[index].status = status;
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    _orders.removeWhere((o) => (o.supabaseId ?? o.id) == orderId);
  }
}
