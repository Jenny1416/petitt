import '../../domain/models/order.dart';
import '../../domain/ports/order_repository.dart';
import '../../domain/ports/product_repository.dart';

/// CAPA DE APLICACIÓN - Caso de Uso
/// Implementa la lógica de negocio pura de la aplicación.
/// 
/// PATRÓN HEXAGONAL: Esta clase es un "Orquestador". No sabe si los datos vienen
/// de una API o de SharedPreferences; solo interactúa con "Puertos" (Interfaces).
class CreateOrderUseCase {
  // Puertos (Interfaces) definidos en la capa de Dominio.
  // La implementación real (Adaptador) será inyectada por GetX.
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;

  /// Inyección de Dependencias:
  /// GetX se encarga de instanciar los adaptadores de infraestructura 
  /// (ej. SharedPrefsOrderAdapter) y pasarlos aquí como implementaciones de los puertos.
  CreateOrderUseCase(this._orderRepository, this._productRepository);

  /// Ejecuta la acción de crear un pedido.
  /// 
  /// Este flujo coordina dos puertos diferentes:
  /// 1. Persistencia del pedido (vía OrderRepository).
  /// 2. Actualización de inventario (vía ProductRepository).
  Future<void> execute(OrderModel order) async {
    // El adaptador de infraestructura que implemente 'createOrder' decidirá
    // si guarda esto en una base de datos local (SharedPreferences) o remota.
    await _orderRepository.createOrder(order);

    // Lógica de negocio: Por cada ítem en el pedido, actualizamos el stock.
    for (var item in order.items) {
      await _productRepository.updateStock(item.product.id, item.quantity);
    }
  }
}
