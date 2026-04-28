import 'cart_item.dart';

enum OrderStatus { processing, shipping, delivered, cancelled }

class TrackingStep {
  final String title;
  final String description;
  String date; // Removido final para permitir actualización en confirmDelivery
  bool isCompleted;

  TrackingStep({
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });
}

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
