import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/review.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';

class AppState extends ChangeNotifier {
  final auth = AuthService();
  List<Product> products = [];
  final List<CartItem> cart = [];
  final List<Product> favorites = [];
  final List<OrderModel> orders = [];
  String? lastResetEmail;
  int homeTabIndex = 0;

  void setHomeTabIndex(int index) {
    homeTabIndex = index;
    notifyListeners();
  }

  double get subtotal => cart.fold(0, (s, i) => s + i.total);
  double get shipping => subtotal >= 50000 || subtotal == 0 ? 0 : 7000;
  double get total => subtotal + shipping;

  Future<void> init() async {
    products = await ProductService().loadProducts();
    if (orders.isEmpty && products.isNotEmpty) {
      _generateMockOrders();
    }
    notifyListeners();
  }

  void _generateMockOrders() {
    orders.add(OrderModel(
      id: 'PET-TEST01',
      date: '15/10/2023',
      status: OrderStatus.delivered,
      address: 'Calle Falsa 123',
      payment: 'Visa',
      items: [CartItem(products[0], quantity: 1)],
      total: products[0].price,
      tracking: [
        TrackingStep(title: 'Pedido Recibido', description: 'Hemos recibido tu pedido.', date: '15/10 10:00', isCompleted: true),
        TrackingStep(title: 'Entregado', description: 'Tu pedido ha sido entregado.', date: '15/10 18:00', isCompleted: true),
      ],
    ));

    orders.add(OrderModel(
      id: 'PET-TEST02',
      date: '14/10/2023',
      status: OrderStatus.shipping,
      address: 'Avenida Siempre Viva 742',
      payment: 'PayPal',
      items: [CartItem(products[1], quantity: 2)],
      total: products[1].price * 2,
      tracking: [
        TrackingStep(title: 'Pedido Recibido', description: 'Recibido.', date: '14/10 09:00', isCompleted: true),
        TrackingStep(title: 'En camino', description: 'En reparto.', date: '15/10 08:00', isCompleted: true),
      ],
    ));
  }

  List<Product> search(String q, String cat) {
    return products.where((p) =>
            (cat == 'Todos' || p.category == cat) &&
            (q.isEmpty || p.name.toLowerCase().contains(q.toLowerCase()))).toList();
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

  OrderModel createOrder(String address, String payment) {
    final id = 'PET-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final order = OrderModel(
      id: id,
      date: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      status: OrderStatus.processing,
      address: address,
      payment: payment,
      items: cart.map((e) => CartItem(e.product, quantity: e.quantity)).toList(),
      total: total,
      tracking: [
        TrackingStep(title: 'Pedido Recibido', description: 'Estamos procesando tu pedido.', date: '${DateTime.now().day}/${DateTime.now().month}', isCompleted: true),
        TrackingStep(title: 'Preparando', description: 'Embalando productos.', date: ''),
      ],
    );
    orders.insert(0, order);
    for (var item in cart) {
      final product = products.firstWhere((p) => p.id == item.product.id);
      product.stock -= item.quantity;
    }
    cart.clear();
    notifyListeners();
    return order;
  }

  void cancelOrder(OrderModel order) {
    order.status = OrderStatus.cancelled;
    order.tracking.removeWhere((step) => !step.isCompleted);
    order.tracking.add(TrackingStep(
      title: 'Pedido Cancelado',
      description: 'El pedido ha sido cancelado exitosamente.',
      date: '${DateTime.now().day}/${DateTime.now().month} ${DateTime.now().hour}:${DateTime.now().minute}',
      isCompleted: true,
    ));
    notifyListeners();
  }

  void confirmDelivery(OrderModel order) {
    order.status = OrderStatus.delivered;
    for (var step in order.tracking) {
      if (!step.isCompleted) {
        step.isCompleted = true;
        step.date = '${DateTime.now().day}/${DateTime.now().month} ${DateTime.now().hour}:${DateTime.now().minute}';
      }
    }
    if (!order.tracking.any((s) => s.title == 'Entregado')) {
      order.tracking.add(TrackingStep(
        title: 'Entregado',
        description: 'Has confirmado la recepción del pedido.',
        date: '${DateTime.now().day}/${DateTime.now().month} ${DateTime.now().hour}:${DateTime.now().minute}',
        isCompleted: true,
      ));
    }
    notifyListeners();
  }

  void rateProduct(OrderModel order, String productId, double stars, String comment) {
    if (!order.reviewedProductIds.contains(productId)) {
      if (order.id != 'DIRECT') {
        order.reviewedProductIds.add(productId);
      }
      
      final product = products.firstWhere((p) => p.id == productId);
      final newReview = ReviewModel(
        userName: auth.currentUser?.name ?? 'Usuario Petitt',
        date: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        comment: comment.isEmpty ? '¡Excelente producto!' : comment,
        rating: stars,
      );
      
      product.reviews.add(newReview);
      
      double totalStars = product.reviews.fold(0.0, (prev, element) => prev + element.rating);
      product.rating = totalStars / product.reviews.length;

      notifyListeners();
    }
  }

  void toggleReviewLike(ReviewModel review) {
    if (review.isLikedByMe) {
      review.likes--;
      review.isLikedByMe = false;
    } else {
      review.likes++;
      review.isLikedByMe = true;
    }
    notifyListeners();
  }
}
