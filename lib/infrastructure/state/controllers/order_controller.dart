import 'package:get/get.dart';
import '../../../domain/models/order.dart';
import '../../../domain/models/cart_item.dart';
import '../../../application/orders/create_order_use_case.dart';
import '../../../domain/ports/order_repository.dart';

import '../../../domain/ports/local_storage_repository.dart';

class OrderController extends GetxController {
  final CreateOrderUseCase _createOrderUseCase;
  final OrderRepository _orderRepository;
  final LocalStorageRepository _storageRepository;

  OrderController(this._createOrderUseCase, this._orderRepository, this._storageRepository);

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  
  final RxList<Map<String, String>> addresses = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final saved = await _storageRepository.getAddresses();
    if (saved.isEmpty) {
      // Direcciones por defecto si no hay nada guardado
      addresses.value = [
        {'title': 'Casa', 'address': 'Calle 72 # 45 - 20, Barranquilla', 'type': 'Principal'},
        {'title': 'Trabajo', 'address': 'Carrera 53 # 102 - 18, Oficina 402, Barranquilla', 'type': 'Secundaria'},
      ];
      await _storageRepository.saveAddresses(addresses);
    } else {
      addresses.value = saved;
    }
  }

  Future<void> loadOrders() async {
    orders.value = await _orderRepository.getOrders();
  }

  Future<OrderModel> createOrder(String address, String payment, List<CartItem> items, double total) async {
    final order = await _createOrderUseCase.execute(
      address: address,
      payment: payment,
      items: items,
      total: total,
    );
    orders.insert(0, order);
    return order;
  }

  void cancelOrder(OrderModel order) {
    order.status = OrderStatus.cancelled;
    order.tracking.add(TrackingStep(
      title: 'Pedido Cancelado',
      description: 'El pedido ha sido cancelado.',
      date: '${DateTime.now().day}/${DateTime.now().month}',
      isCompleted: true,
    ));
    orders.refresh();
  }

  void confirmDelivery(OrderModel order) {
    order.status = OrderStatus.delivered;
    orders.refresh();
  }

  void markAsReviewed(OrderModel order, String productId) {
    if (!order.reviewedProductIds.contains(productId)) {
      order.reviewedProductIds.add(productId);
      orders.refresh();
    }
  }

  void addAddress(String title, String address) {
    addresses.add({'title': title, 'address': address, 'type': 'Secundaria'});
    _storageRepository.saveAddresses(addresses);
  }

  void removeAddress(int index) {
    addresses.removeAt(index);
    _storageRepository.saveAddresses(addresses);
  }

  void setPrimaryAddress(int index) {
    for (var i = 0; i < addresses.length; i++) {
      addresses[i]['type'] = (i == index) ? 'Principal' : 'Secundaria';
    }
    addresses.refresh();
    _storageRepository.saveAddresses(addresses);
  }
}
