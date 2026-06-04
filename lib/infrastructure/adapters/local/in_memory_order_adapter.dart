import '../../../domain/models/order.dart';
import '../../../domain/ports/order_repository.dart';

class InMemoryOrderAdapter implements OrderRepository {
  final List<OrderModel> _orders = [];

  @override
  Future<List<OrderModel>> getOrders() async {
    return _orders;
  }

  @override
  Future<void> createOrder(OrderModel order) async {
    _orders.insert(0, order);
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final order = _orders.firstWhere((o) => o.id == orderId);
    order.status = status;
  }
}
