import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/order.dart';
import '../../../domain/models/cart_item.dart';
import '../../../domain/models/product.dart';
import '../../../domain/ports/order_repository.dart';

class SupabaseOrderAdapter implements OrderRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<OrderModel>> getOrders() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('orders')
          .select('*, order_items(*, products(*)), order_tracking(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) {
        final items = (json['order_items'] as List).map((itemJson) {
          final productJson = itemJson['products'];
          if (productJson['image_url'] == null || productJson['image_url'].toString().isEmpty) {
            productJson['image_url'] = 'assets/images/1.png';
          }
          final product = Product.fromJson(productJson);
          return CartItem(product, quantity: itemJson['quantity']);
        }).toList();

        final tracking = (json['order_tracking'] as List).map((t) => TrackingStep(
          title: t['status'],
          description: t['description'] ?? '',
          date: t['created_at'].toString().split('T')[0],
          isCompleted: true,
        )).toList();

        return OrderModel(
          id: json['id'].toString().substring(0, 8).toUpperCase(),
          supabaseId: json['id'].toString(),
          date: json['created_at'].toString().split('T')[0],
          status: _parseStatus(json['status']),
          address: json['address_text'] ?? 'Sin dirección',
          payment: json['payment_text'] ?? 'No especificado',
          items: items,
          total: (json['total'] as num).toDouble(),
          tracking: tracking,
        );
      }).toList();
    } catch (e) {
      print('DEBUG: Error al obtener órdenes: $e');
      return [];
    }
  }

  @override
  Future<String> createOrder(OrderModel order) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      final orderResponse = await _client.from('orders').insert({
        'user_id': userId,
        'total': order.total,
        'status': 'shipping',
        'address_text': order.address,
        'payment_text': order.payment,
      }).select('id').single();

      final orderId = orderResponse['id'].toString();

      final itemsToInsert = order.items.map((item) => {
        'order_id': orderId,
        'product_id': item.product.id,
        'quantity': item.quantity,
        'price': item.product.price,
      }).toList();

      await _client.from('order_items').insert(itemsToInsert);

      await _client.from('order_tracking').insert({
        'order_id': orderId,
        'status': 'Confirmado',
        'description': 'Tu pedido ha sido recibido y está en camino.',
      });

      return orderId;
    } catch (e) {
      print('DEBUG: Error al crear orden: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _client
          .from('orders')
          .update({'status': status.name})
          .eq('id', orderId);

      String desc = status == OrderStatus.delivered 
          ? '¡Pedido entregado con éxito!' 
          : 'El pedido ha sido actualizado.';

      await _client.from('order_tracking').insert({
        'order_id': orderId,
        'status': status == OrderStatus.delivered ? 'Recibido' : status.name,
        'description': desc,
      });
    } catch (e) {
      print('DEBUG: Error al actualizar estado: $e');
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      await _client.from('order_tracking').delete().eq('order_id', orderId);
      await _client.from('order_items').delete().eq('order_id', orderId);
      await _client.from('orders').delete().eq('id', orderId);
    } catch (e) {
      print('DEBUG: Error al eliminar orden: $e');
      rethrow;
    }
  }

  OrderStatus _parseStatus(String status) {
    if (status == 'shipping') return OrderStatus.shipping;
    if (status == 'delivered') return OrderStatus.delivered;
    if (status == 'cancelled') return OrderStatus.cancelled;
    return OrderStatus.processing;
  }
}
