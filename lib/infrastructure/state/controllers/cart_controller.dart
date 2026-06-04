import 'package:get/get.dart';
import '../../../domain/models/product.dart';
import '../../../domain/models/cart_item.dart';

/// CAPA DE INFRAESTRUCTURA / PRESENTACIÓN - Controlador GetX
/// Gestiona el estado del carrito de compras de forma reactiva.
/// 
/// GETX: Este controlador mantiene la lista de productos seleccionados por el usuario
/// en memoria y calcula totales automáticamente.
class CartController extends GetxController {
  // GESTIÓN DE ESTADO: Lista observable de ítems del carrito.
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  // PROPIEDADES COMPUTADAS: Se recalculan automáticamente cuando 'cartItems' cambia.
  double get subtotal => cartItems.fold(0, (s, i) => s + i.total);
  double get shipping => (subtotal >= 50000 || subtotal == 0) ? 0 : 7000;
  double get total => subtotal + shipping;

  /// Añade un producto al carrito o incrementa su cantidad si ya existe.
  void addToCart(Product p) {
    final i = cartItems.indexWhere((e) => e.product.id == p.id);
    if (i >= 0) {
      cartItems[i].quantity++;
      // Notifica a GetX que un elemento interno cambió.
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(p));
    }
  }

  /// Elimina un producto completamente del carrito.
  void removeFromCart(Product p) {
    cartItems.removeWhere((e) => e.product.id == p.id);
  }

  /// Cambia la cantidad de un ítem (+1 o -1).
  void changeQty(Product p, int delta) {
    final item = cartItems.firstWhere((e) => e.product.id == p.id);
    item.quantity = (item.quantity + delta).clamp(1, 99);
    cartItems.refresh();
  }

  /// Limpia el carrito después de una compra exitosa.
  void clearCart() {
    cartItems.clear();
  }
}
