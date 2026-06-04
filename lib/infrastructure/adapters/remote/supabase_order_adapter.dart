import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/order.dart';
import '../../../domain/models/cart_item.dart';
import '../../../domain/models/product.dart';
import '../../../domain/ports/order_repository.dart';

/// CAPA DE INFRAESTRUCTURA - Adaptador Remoto
/// Implementación concreta del puerto [OrderRepository] usando Supabase.
///
/// PATRÓN HEXAGONAL: Reemplaza al [InMemoryOrderAdapter]. Los pedidos ahora
/// se persisten en la tabla `orders` de Supabase y son accesibles entre sesiones.
class SupabaseOrderAdapter implements OrderRepository {
  final _client = Supabase.instance.client;

  /// Recupera todos los pedidos del usuario autenticado actualmente.
  /// Los pedidos se ordenan del más reciente al más antiguo.
  @override
  Future<List<OrderModel>> getOrders() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((row) => _rowToOrder(row as Map<String, dynamic>))
        .toList();
  }

  /// Guarda un nuevo pedido en la tabla `orders` de Supabase.
  @override
  Future<void> createOrder(OrderModel order) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final payload = order.toJson();
    payload['user_id'] = userId;

    await _client.from('orders').insert(payload);
  }

  /// Actualiza el estado de un pedido existente.
  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _client
        .from('orders')
        .update({'status': status.name}).eq('id', orderId);
  }

  // ── Helpers de deserialización ────────────────────────────────────────────

  /// Convierte una fila de Supabase en un [OrderModel].
  /// Los items (JSONB) se reconstruyen como [CartItem] con un [Product] mínimo.
  OrderModel _rowToOrder(Map<String, dynamic> row) {
    final itemsRaw = row['items'] as List? ?? [];
    final items = itemsRaw
        .map((i) => _jsonToCartItem(i as Map<String, dynamic>))
        .toList();

    final trackingRaw = row['tracking'] as List? ?? [];
    final tracking = trackingRaw
        .map((t) => TrackingStep.fromJson(t as Map<String, dynamic>))
        .toList();

    return OrderModel(
      id: row['id'] as String,
      date: row['date'] as String? ?? '',
      status: orderStatusFromString(row['status'] as String? ?? 'processing'),
      address: row['address'] as String? ?? '',
      payment: row['payment'] as String? ?? '',
      total: (row['total'] as num?)?.toDouble() ?? 0.0,
      items: items,
      tracking: tracking,
    );
  }

  /// Reconstruye un [CartItem] desde el JSONB almacenado en la columna `items`.
  CartItem _jsonToCartItem(Map<String, dynamic> json) {
    // Reconstrucción mínima del producto (solo los campos necesarios para mostrar el historial).
    final product = Product(
      id: json['product_id'] as String? ?? '',
      name: json['product_name'] as String? ?? '',
      brand: '',
      category: '',
      type: '',
      price: (json['product_price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: 0.0,
      discount: 0,
      rating: 0.0,
      stock: 0,
      image: json['product_image'] as String? ?? '',
      description: '',
      tags: [],
    );

    return CartItem(product, quantity: json['quantity'] as int? ?? 1);
  }
}
