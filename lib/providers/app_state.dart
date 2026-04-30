import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/review.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';

/// Clase AppState: Maneja el estado global de la aplicación utilizando el patrón Provider.
/// Centraliza la lógica de negocio, autenticación, carrito, favoritos y pedidos.
/// Implementa persistencia con SharedPreferences y manejo de datos dinámicos (ArrayList).
class AppState extends ChangeNotifier {
  final auth = AuthService();
  
  // Manejo de Datos (ArrayList/List): Listas dinámicas de productos, carrito y pedidos.
  List<Product> products = []; 
  final List<CartItem> cart = []; 
  final List<Product> favorites = []; 
  final List<OrderModel> orders = []; 
  
  // Lista de direcciones del usuario (Estructura de datos dinámica)
  final List<Map<String, String>> addresses = [
    {
      'title': 'Casa',
      'address': 'Calle 72 # 45 - 20, Barranquilla',
      'type': 'Principal'
    },
    {
      'title': 'Trabajo',
      'address': 'Carrera 53 # 102 - 18, Oficina 402, Barranquilla',
      'type': 'Secundaria'
    },
  ];
  
  String? lastResetEmail;
  int homeTabIndex = 0; // Control de navegación (UX)

  /// Cambia la pestaña de navegación principal (UX)
  void setHomeTabIndex(int index) {
    homeTabIndex = index;
    notifyListeners();
  }

  // Getters calculados para la UI/UX (Carrito)
  double get subtotal => cart.fold(0, (s, i) => s + i.total);
  double get shipping => subtotal >= 50000 || subtotal == 0 ? 0 : 7000;
  double get total => subtotal + shipping;

  /// Inicialización del estado: Carga datos de JSON y SharedPreferences (Manejo de Datos)
  Future<void> init() async {
    // 1. Uso de JSON: Carga de productos desde el archivo assets/data/products.json
    products = await ProductService().loadProducts();
    
    // 2. Uso de SharedPreferences: Recuperar favoritos del disco
    await _loadPreferences();
    
    notifyListeners();
  }

  /// Recupera datos de SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final favIds = prefs.getStringList('favorite_ids') ?? [];
    
    favorites.clear();
    for (var id in favIds) {
      try {
        final p = products.firstWhere((p) => p.id == id);
        favorites.add(p);
      } catch (_) {
        // Producto ya no existe en el JSON
      }
    }
  }

  /// Persiste favoritos en SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = favorites.map((p) => p.id).toList();
    await prefs.setStringList('favorite_ids', ids);
  }

  /// Lógica de búsqueda y filtrado (Manejo de listas dinámicas)
  List<Product> search(String q, String catOrType) {
    return products.where((p) =>
            (catOrType == 'Todos' || p.category == catOrType || p.type == catOrType) &&
            (q.isEmpty || p.name.toLowerCase().contains(q.toLowerCase()))).toList();
  }

  /// Añadir al carrito (ArrayList Management)
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

  /// Alternar favorito y persistir con Shared Preferences
  void toggleFavorite(Product p) {
    if (favorites.contains(p)) {
      favorites.remove(p);
    } else {
      favorites.add(p);
    }
    _saveFavorites(); 
    notifyListeners();
  }

  bool isFav(Product p) => favorites.contains(p);

  /// Autenticación lógica (UX y Seguridad básica)
  Future<bool> login(String email, String password) async {
    final success = await auth.login(email, password);
    if (success) {
      orders.clear();
      // Solo cargar pedidos mock para el usuario demo (Origen de los datos)
      if (email.trim().toLowerCase() == 'demo@petit.com' && products.isNotEmpty) {
        _generateMockOrders();
      }
      notifyListeners();
    }
    return success;
  }

  Future<bool> register(String email, String password, String phone) async {
    final success = await auth.register(email, password, phone);
    if (success) {
      orders.clear();
      notifyListeners();
    }
    return success;
  }

  /// Generación de datos de prueba (Manejo de listas)
  void _generateMockOrders() {
    if (orders.isNotEmpty) return;
    const mockOrder1 = 'PET-TEST01';
    orders.add(OrderModel(
      id: mockOrder1,
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
  }

  /// Crear un nuevo pedido y actualizar stock (Lógica de Datos)
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
    
    // Actualización dinámica de stock en la lista de productos
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
    order.tracking.add(TrackingStep(
      title: 'Pedido Cancelado',
      description: 'El pedido ha sido cancelado.',
      date: '${DateTime.now().day}/${DateTime.now().month}',
      isCompleted: true,
    ));
    notifyListeners();
  }

  void confirmDelivery(OrderModel order) {
    order.status = OrderStatus.delivered;
    notifyListeners();
  }

  void updateUserInfo(String name, String phone) {
    if (auth.currentUser != null) {
      auth.currentUser!.name = name;
      auth.currentUser!.phone = phone;
      notifyListeners();
    }
  }

  void logout() {
    auth.currentUser = null;
    cart.clear();
    favorites.clear();
    orders.clear();
    homeTabIndex = 0;
    notifyListeners();
  }

  /// Calificar un producto y añadir reseña (Manejo de Datos yArrayList)
  void rateProduct(OrderModel order, String productId, double stars, String comment) {
    if (!order.reviewedProductIds.contains(productId)) {
      order.reviewedProductIds.add(productId);
      
      final product = products.firstWhere((p) => p.id == productId);
      final newReview = ReviewModel(
        userName: auth.currentUser?.name ?? 'Usuario Petitt',
        date: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        comment: comment.isEmpty ? '¡Excelente producto!' : comment,
        rating: stars,
      );
      
      product.reviews.add(newReview);
      
      // Recalcular promedio de estrellas
      double totalStars = product.reviews.fold(0.0, (prev, element) => prev + element.rating);
      product.rating = totalStars / product.reviews.length;

      notifyListeners();
    }
  }

  /// Toggle like en una reseña (UX Feedback)
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

  // Métodos adicionales para direcciones (ArrayList manipulation)
  void addAddress(String title, String address) {
    addresses.add({'title': title, 'address': address, 'type': 'Secundaria'});
    notifyListeners();
  }

  void removeAddress(int index) {
    addresses.removeAt(index);
    notifyListeners();
  }

  void setPrimaryAddress(int index) {
    for (var i = 0; i < addresses.length; i++) {
      addresses[i]['type'] = (i == index) ? 'Principal' : 'Secundaria';
    }
    notifyListeners();
  }
}
