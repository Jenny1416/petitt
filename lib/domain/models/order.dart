import 'cart_item.dart';

/// CAPA DE DOMINIO - Modelo
/// Define los estados posibles de un pedido.
enum OrderStatus { processing, shipping, delivered, cancelled }

/// Representa un hito en el seguimiento de un pedido.
class TrackingStep {
  final String title;
  final String description;
  String date; 
  bool isCompleted;

  TrackingStep({
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });
}

/// CAPA DE DOMINIO - Modelo
/// Entidad principal que representa una orden de compra.
/// 
/// PATRÓN HEXAGONAL: Esta clase es pura lógica de datos. No depende de cómo
/// se guarde el pedido, solo define su estructura.
class OrderModel {
  final String id, date, address, payment;
  final List<CartItem> items; 
  final double total;
  OrderStatus status;
  final List<TrackingStep> tracking;
  final List<String> reviewedProductIds = []; 

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
