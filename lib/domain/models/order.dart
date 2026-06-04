import 'package:get/get.dart';
import 'cart_item.dart';

enum OrderStatus { processing, shipping, delivered, cancelled }

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

class OrderModel {
  final String id, date, address, payment;
  final String? supabaseId;
  final List<CartItem> items; 
  final double total;
  OrderStatus status;
  final List<TrackingStep> tracking;
  // Usamos RxList para que la UI de reseñas reaccione al instante
  final RxList<String> reviewedProductIds = <String>[].obs; 

  OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.address,
    required this.payment,
    required this.items,
    required this.total,
    required this.tracking,
    this.supabaseId,
    List<String>? reviewedIds,
  }) {
    if (reviewedIds != null) {
      reviewedProductIds.assignAll(reviewedIds);
    }
  }
}
