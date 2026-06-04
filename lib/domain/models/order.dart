import 'cart_item.dart';

/// CAPA DE DOMINIO - Modelo
/// Define los estados posibles de un pedido.
enum OrderStatus { processing, shipping, delivered, cancelled }

/// Convierte un String de la BD al enum OrderStatus.
OrderStatus orderStatusFromString(String s) {
  return OrderStatus.values.firstWhere(
    (e) => e.name == s,
    orElse: () => OrderStatus.processing,
  );
}

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

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'date': date,
        'is_completed': isCompleted,
      };

  factory TrackingStep.fromJson(Map<String, dynamic> json) => TrackingStep(
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        date: json['date'] as String? ?? '',
        isCompleted: json['is_completed'] as bool? ?? false,
      );
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

  /// Serializa el pedido para guardarlo en Supabase.
  /// Los items se guardan como JSONB con id, nombre, precio y cantidad.
  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'status': status.name,
        'address': address,
        'payment': payment,
        'total': total,
        'items': items
            .map((i) => {
                  'product_id': i.product.id,
                  'product_name': i.product.name,
                  'product_image': i.product.image,
                  'product_price': i.product.price,
                  'quantity': i.quantity,
                })
            .toList(),
        'tracking': tracking.map((t) => t.toJson()).toList(),
      };
}

