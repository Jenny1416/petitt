import 'package:get/get.dart';
import '../../../domain/models/order.dart';
import '../../../domain/models/cart_item.dart';
import '../../../application/orders/create_order_use_case.dart';
import '../../../domain/ports/order_repository.dart';
import '../../../domain/ports/local_storage_repository.dart';
import '../../../domain/ports/address_repository.dart';
import 'auth_controller.dart';

class OrderController extends GetxController {
  final CreateOrderUseCase _createOrderUseCase;
  final OrderRepository _orderRepository;
  final LocalStorageRepository _storageRepository;
  final AddressRepository _addressRepository;

  OrderController(
    this._createOrderUseCase, 
    this._orderRepository, 
    this._storageRepository,
    this._addressRepository
  );

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<Map<String, String>> addresses = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    final user = Get.find<AuthController>().currentUser;
    if (user == null) return;

    // Cargamos de Supabase
    final remoteAddresses = await _addressRepository.getAddresses(user.id);
    if (remoteAddresses.isNotEmpty) {
      addresses.assignAll(remoteAddresses);
    } else {
      // Si no hay en nube, intentamos local
      final local = await _storageRepository.getAddresses();
      addresses.assignAll(local);
    }
  }

  Future<void> addAddress(String title, String address) async {
    final user = Get.find<AuthController>().currentUser;
    if (user == null) return;

    try {
      await _addressRepository.addAddress(user.id, title, address);
      await loadAddresses(); // Recargamos de la nube
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar la dirección en la nube');
      // Fallback local
      addresses.add({'title': title, 'address': address, 'type': 'Secundaria'});
      _storageRepository.saveAddresses(addresses);
    }
  }

  Future<void> removeAddress(int index) async {
    final id = addresses[index]['id'];
    if (id != null) {
      await _addressRepository.deleteAddress(id);
    }
    addresses.removeAt(index);
    _storageRepository.saveAddresses(addresses);
  }

  Future<void> setPrimaryAddress(int index) async {
    final user = Get.find<AuthController>().currentUser;
    final id = addresses[index]['id'];
    if (user != null && id != null) {
      await _addressRepository.setPrimaryAddress(user.id, id);
      await loadAddresses();
    }
  }

  // --- Lógica de Órdenes ---
  Future<void> loadOrders({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    try {
      final fetchedOrders = await _orderRepository.getOrders();
      orders.assignAll(fetchedOrders);
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  Future<OrderModel> createOrder(String address, String payment, List<CartItem> items, double total) async {
    isLoading.value = true;
    try {
      final order = await _createOrderUseCase.execute(
        address: address,
        payment: payment,
        items: items,
        total: total,
      );
      orders.insert(0, order);
      return order;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(OrderModel order, OrderStatus status) async {
    try {
      final idToUpdate = order.supabaseId ?? order.id;
      
      // 1. Buscamos el índice en la lista reactiva
      final index = orders.indexWhere((o) => (o.supabaseId ?? o.id) == idToUpdate);
      
      if (index != -1) {
        // 2. Modificamos el objeto y notificamos a la lista
        final updatedOrder = orders[index];
        updatedOrder.status = status;
        
        // Añadimos hito de tracking local
        updatedOrder.tracking.add(TrackingStep(
          title: status == OrderStatus.delivered ? 'Recibido' : status.name,
          description: status == OrderStatus.delivered ? '¡Pedido entregado con éxito!' : 'Estado actualizado.',
          date: '${DateTime.now().day}/${DateTime.now().month}',
          isCompleted: true,
        ));
        
        // Reemplazamos la instancia para asegurar que GetX detecte el cambio
        orders[index] = updatedOrder;
        orders.refresh();
      }

      // 3. Persistencia en segundo plano
      await _orderRepository.updateOrderStatus(idToUpdate, status);
      
    } catch (e) {
      print('DEBUG: Error al actualizar estado: $e');
      // Solo en caso de error crítico recargamos todo
      await loadOrders();
    }
  }

  Future<void> cancelOrder(OrderModel order) async {
    try {
      final idToDelete = order.supabaseId ?? order.id;
      
      // Eliminación reactiva local inmediata
      orders.removeWhere((o) => (o.supabaseId ?? o.id) == idToDelete);
      
      await _orderRepository.deleteOrder(idToDelete);
      Get.snackbar('Pedido Cancelado', 'El pedido ha sido eliminado correctamente.');
    } catch (e) {
      print('Error al cancelar pedido: $e');
      await loadOrders(); // Restaurar si falló la eliminación en servidor
      Get.snackbar('Error', 'No se pudo cancelar el pedido. Verifique su conexión.');
    }
  }

  Future<void> confirmDelivery(OrderModel order) async {
    await updateStatus(order, OrderStatus.delivered);
    Get.snackbar('¡Excelente!', 'Pedido marcado como recibido. Ya puedes calificar tus productos.');
  }

  void markAsReviewed(OrderModel order, String productId) {
    if (!order.reviewedProductIds.contains(productId)) {
      order.reviewedProductIds.add(productId);
      orders.refresh();
    }
  }
}
