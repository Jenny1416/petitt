import 'package:get/get.dart';
import '../../../domain/models/product.dart';
import '../../../domain/models/cart_item.dart';
import '../../../domain/ports/local_storage_repository.dart';
import '../../../domain/ports/cart_repository.dart';
import '../controllers/auth_controller.dart';

/// CAPA DE INFRAESTRUCTURA / PRESENTACIÓN - Controlador GetX
/// Gestiona el carrito sincronizando entre local (SharedPreferences) y remoto (Supabase).
class CartController extends GetxController {
  final LocalStorageRepository _localStorageRepository;
  final CartRepository _cartRepository;
  
  CartController(this._localStorageRepository, this._cartRepository);

  final RxList<CartItem> cartItems = <CartItem>[].obs;

  double get subtotal => cartItems.fold(0, (s, i) => s + i.total);
  double get shipping => (subtotal >= 50000 || subtotal == 0) ? 0 : 7000;
  double get total => subtotal + shipping;

  @override
  void onInit() {
    super.onInit();
    _loadCart();
    
    final authController = Get.find<AuthController>();

    // 1. Sincronización inmediata si ya hay sesión al arrancar
    if (authController.currentUser != null) {
      _syncCartFromRemote(authController.currentUser!.id);
    }
    
    // 2. Escucha de cambios de sesión futuros (Login/Logout)
    ever(authController.rxCurrentUser, (user) {
      if (user != null) {
        _syncCartFromRemote(user.id);
      } else {
        cartItems.clear();
        _localStorageRepository.saveCart([]);
      }
    });
  }

  /// Carga el carrito desde el almacenamiento local al iniciar.
  Future<void> _loadCart() async {
    final savedCart = await _localStorageRepository.getCart();
    if (savedCart.isNotEmpty) {
      cartItems.value = savedCart.map((e) => CartItem.fromJson(e)).toList();
    }
  }

  /// Sincroniza el carrito desde Supabase al iniciar sesión.
  Future<void> _syncCartFromRemote(String userId) async {
    final remoteItems = await _cartRepository.getRemoteCart(userId);
    if (remoteItems.isNotEmpty) {
      cartItems.assignAll(remoteItems);
      _saveLocalCart();
    }
  }

  /// Persiste el estado actual en el almacenamiento local.
  Future<void> _saveLocalCart() async {
    final cartJson = cartItems.map((e) => e.toJson()).toList();
    await _localStorageRepository.saveCart(cartJson);
  }

  /// Añade un producto al carrito y sincroniza con remoto si hay sesión.
  void addToCart(Product p, {int qty = 1}) async {
    final i = cartItems.indexWhere((e) => e.product.id == p.id);
    int newQty = qty;
    
    if (i >= 0) {
      cartItems[i].quantity += qty;
      newQty = cartItems[i].quantity;
    } else {
      cartItems.add(CartItem(p, quantity: qty));
    }
    
    cartItems.refresh();
    _saveLocalCart();

    final userId = Get.find<AuthController>().currentUser?.id;
    if (userId != null) {
      await _cartRepository.addToRemoteCart(userId, p.id, newQty);
    }
  }

  void removeFromCart(Product p) async {
    cartItems.removeWhere((e) => e.product.id == p.id);
    _saveLocalCart();

    final userId = Get.find<AuthController>().currentUser?.id;
    if (userId != null) {
      await _cartRepository.removeFromRemoteCart(userId, p.id);
    }
  }

  void changeQty(Product p, int delta) async {
    final i = cartItems.indexWhere((e) => e.product.id == p.id);
    if (i >= 0) {
      final newQty = (cartItems[i].quantity + delta).clamp(1, 99);
      cartItems[i].quantity = newQty;
      cartItems.refresh();
      _saveLocalCart();

      final userId = Get.find<AuthController>().currentUser?.id;
      if (userId != null) {
        await _cartRepository.updateRemoteCartQuantity(userId, p.id, newQty);
      }
    }
  }

  void clearCart() async {
    cartItems.clear();
    _saveLocalCart();

    final userId = Get.find<AuthController>().currentUser?.id;
    if (userId != null) {
      await _cartRepository.clearRemoteCart(userId);
    }
  }
}
