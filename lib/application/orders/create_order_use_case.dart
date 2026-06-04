import '../../domain/models/order.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/ports/order_repository.dart';
import '../../domain/ports/product_repository.dart';

/// CAPA DE APLICACIÓN - Caso de Uso
/// Orquesta la creación de un pedido y la actualización de stock.
class CreateOrderUseCase {
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;

  CreateOrderUseCase(this._orderRepository, this._productRepository);

  Future<OrderModel> execute({
    required String address,
    required String payment,
    required List<CartItem> items,
    required double total,
  }) async {
    // REGLA DE NEGOCIO: Generación de identificador único de pedido
    final id = 'PET-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    
    // REGLA DE NEGOCIO: El estado inicial de todo pedido es 'processing'
    final order = OrderModel(
      id: id,
      date: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      status: OrderStatus.processing,
      address: address,
      payment: payment,
      items: items.map((e) => CartItem(e.product, quantity: e.quantity)).toList(),
      total: total,
      tracking: [
        TrackingStep(
          title: 'Pedido Recibido', 
          description: 'Estamos procesando tu pedido.', 
          date: '${DateTime.now().day}/${DateTime.now().month}', 
          isCompleted: true
        ),
        TrackingStep(title: 'Preparando', description: 'Embalando productos.', date: ''),
      ],
    );

    // Persistencia del pedido a través del puerto
    await _orderRepository.createOrder(order);

    // Lógica de negocio secundaria: Actualizar inventario
    for (var item in order.items) {
      await _productRepository.updateStock(item.product.id, item.quantity);
    }

    return order;
  }
}
