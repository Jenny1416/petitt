import 'cart_item.dart';

/// Enum OrderStatus: Define los posibles estados de un pedido.
/// Esta es una responsabilidad de la capa de MODELOS para tipar los datos.
enum OrderStatus { processing, shipping, delivered, cancelled }

/// Clase TrackingStep: Estructura de datos para los pasos de seguimiento.
/// Modela la información que se mostrará en la línea de tiempo del pedido.
class TrackingStep {
  final String title;
  final String description;
  String date; // Permite actualización dinámica cuando el estado cambia.
  bool isCompleted;

  TrackingStep({
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });
}

/// Clase OrderModel: Representa un pedido en el sistema.
/// Responsabilidad: Definir la estructura del objeto de negocio (ArrayList de items).
class OrderModel {
  final String id, date, address, payment;
  final List<CartItem> items; // Uso de ArrayList para los productos del pedido
  final double total;
  OrderStatus status;
  final List<TrackingStep> tracking;
  final List<String> reviewedProductIds = []; // Control de reseñas para evitar duplicados

  OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.address,
    required this.payment,
    required this.items,
    required this.total,
    required this.tracking,
  });
}
