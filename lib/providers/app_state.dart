import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';

class AppState extends ChangeNotifier {
  final auth = AuthService();
  List<Product> products = [];
  final List<CartItem> cart = [];
  final List<Product> favorites = [];
  final List<OrderModel> orders = [];
  String? lastResetEmail;
  double get subtotal => cart.fold(0, (s, i) => s + i.total);
  double get shipping => subtotal >= 50000 || subtotal == 0 ? 0 : 7000;
  double get total => subtotal + shipping;
  Future<void> init() async {
    products = await ProductService().loadProducts();
    notifyListeners();
  }

  List<Product> search(String q, String cat) {
    return products
        .where((p) =>
            (cat == 'Todos' || p.category == cat) &&
            (q.isEmpty ||
                p.name.toLowerCase().contains(q.toLowerCase()) ||
                p.brand.toLowerCase().contains(q.toLowerCase())))
        .toList();
  }

  void addToCart(Product p) {
    final i = cart.indexWhere((e) => e.product.id == p.id);
    if (i >= 0) {
      cart[i].quantity++;
    } else {
      cart.add(CartItem(p));
    }
    notifyListeners();
  }

  void removeFromCart(Product p) {
    cart.removeWhere((e) => e.product.id == p.id);
    notifyListeners();
  }

  void changeQty(Product p, int delta) {
    final i = cart.firstWhere((e) => e.product.id == p.id);
    i.quantity = (i.quantity + delta).clamp(1, 99);
    notifyListeners();
  }

  void toggleFavorite(Product p) {
    favorites.contains(p) ? favorites.remove(p) : favorites.add(p);
    notifyListeners();
  }

  bool isFav(Product p) => favorites.contains(p);

  void updateUserInfo({String? name, String? phone}) {
    if (auth.currentUser != null) {
      if (name != null) auth.currentUser!.name = name;
      if (phone != null) auth.currentUser!.phone = phone;
      notifyListeners();
    }
  }

  void logout() {
    auth.currentUser = null;
    notifyListeners();
  }

  OrderModel createOrder(String address, String payment) {
    final id =
        'PET-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final order = OrderModel(
        id: id,
        date:
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        status: 'Pedidos Recibidos',
        address: address,
        payment: payment,
        items:
            cart.map((e) => CartItem(e.product, quantity: e.quantity)).toList(),
        total: total);
    orders.insert(0, order);
    // Reducir stock de los productos
    for (var item in cart) {
      final product = products.firstWhere((p) => p.id == item.product.id);
      product.stock -= item.quantity;
    }
    cart.clear();
    notifyListeners();
    return order;
  }
}
