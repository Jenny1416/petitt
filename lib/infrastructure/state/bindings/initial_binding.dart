import 'package:get/get.dart';
import '../../adapters/local/shared_prefs_adapter.dart';
import '../../adapters/remote/supabase_auth_adapter.dart';
import '../../adapters/remote/supabase_order_adapter.dart';
import '../../adapters/remote/supabase_product_adapter.dart';
import '../../../application/auth/login_use_case.dart';
import '../../../application/auth/register_use_case.dart';
import '../../../application/favorites/toggle_favorite_use_case.dart';
import '../../../application/orders/create_order_use_case.dart';
import '../../../application/products/get_products_use_case.dart';
import '../../../domain/ports/local_storage_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/product_controller.dart';

/// CAPA DE INFRAESTRUCTURA - Bindings (Inyección de Dependencias)
/// Esta clase es el "Pegamento" de la arquitectura.
///
/// PATRÓN HEXAGONAL: Aquí se conectan los Adaptadores concretos con los Puertos del Dominio
/// y se inyectan en los Casos de Uso. Para cambiar de Supabase a otra BD,
/// solo hay que cambiar las líneas de los adaptadores — nada más.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ── 1. ADAPTADORES (Infraestructura) ─────────────────────────────────────
    // Adaptadores REMOTOS: conectan los Puertos del Dominio con Supabase.
    final authAdapter = SupabaseAuthAdapter();
    final productAdapter = SupabaseProductAdapter();
    final orderAdapter = SupabaseOrderAdapter();

    // Adaptador LOCAL: SharedPreferences para datos del dispositivo
    // (favoritos, onboarding, direcciones, sesión local).
    final storageAdapter = SharedPrefsAdapter();

    // Registramos el repositorio de almacenamiento local en GetX.
    Get.put<LocalStorageRepository>(storageAdapter, permanent: true);

    // ── 2. CASOS DE USO (Aplicación) ─────────────────────────────────────────
    // Contienen la lógica de negocio pura. Reciben los adaptadores a través
    // de sus interfaces (Puertos) — NO saben que Supabase existe.
    final loginUseCase = LoginUseCase(authAdapter, storageAdapter);
    final registerUseCase = RegisterUseCase(authAdapter);
    final getProductsUseCase = GetProductsUseCase(productAdapter);
    final createOrderUseCase = CreateOrderUseCase(orderAdapter, productAdapter);
    final toggleFavoriteUseCase = ToggleFavoriteUseCase(storageAdapter);

    // ── 3. CONTROLADORES (GetX) ───────────────────────────────────────────────
    // Orquestan la UI y llaman a los Casos de Uso.
    // 'permanent: true' asegura que el estado no se pierda al navegar.
    Get.put(AuthController(loginUseCase, registerUseCase, authAdapter),
        permanent: true);
    Get.put(
        ProductController(
            getProductsUseCase, toggleFavoriteUseCase, productAdapter, storageAdapter),
        permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(OrderController(createOrderUseCase, orderAdapter, storageAdapter),
        permanent: true);
  }
}

