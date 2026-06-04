import '../models/order.dart';

/// CAPA DE DOMINIO - Puerto (Interface)
/// Define el contrato para la gestión de pedidos.
/// 
/// PATRÓN HEXAGONAL: Los puertos de dominio aseguran que la lógica de negocio
/// sea independiente de la persistencia.
abstract class OrderRepository {
  /// Recupera el historial de pedidos del usuario.
  Future<List<OrderModel>> getOrders();
  
  /// Registra un nuevo pedido en el sistema y devuelve su ID real.
  Future<String> createOrder(OrderModel order);
  
  /// Actualiza el estado de un pedido existente (ej. de 'Procesando' a 'Enviado').
  Future<void> updateOrderStatus(String orderId, OrderStatus status);

  /// Elimina un pedido del sistema.
  Future<void> deleteOrder(String orderId);
}
