import 'cart_item.dart';

class OrderModel {
  final String id, date, status, address, payment;
  final List<CartItem> items;
  final double total;
  OrderModel(
      {required this.id,
      required this.date,
      required this.status,
      required this.address,
      required this.payment,
      required this.items,
      required this.total});
}
