import 'package:get/get.dart';
import '../../adapters/remote/supabase_auth_adapter.dart';
import '../../adapters/remote/supabase_order_adapter.dart';
import '../../adapters/local/json_product_adapter.dart';
import '../../adapters/remote/supabase_product_adapter.dart';
import '../../adapters/local/shared_prefs_adapter.dart';
import '../../../application/auth/login_use_case.dart';
import '../../../application/auth/register_use_case.dart';
import '../../../application/favorites/toggle_favorite_use_case.dart';
import '../../../application/orders/create_order_use_case.dart';
import '../../../application/products/get_products_use_case.dart';
import '../../../application/products/search_products_use_case.dart';
import '../../adapters/remote/supabase_cart_adapter.dart';
import '../../../domain/ports/local_storage_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/product_controller.dart';

/// CAPA DE INFRAESTRUCTURA - Bindings (Inyección de Dependencias)
/// Esta clase es el "Pegamento" de la arquitectura. 
/// 
/// PATRÓN HEXAGONAL: Aquí se conectan los Adaptadores concretos con los Puertos del Dominio
/// y se inyectan en los Casos de Uso.
import '../../adapters/remote/supabase_address_adapter.dart';
import '../../../domain/ports/address_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final authAdapter = SupabaseAuthAdapter();
    final productAdapter = SupabaseProductAdapter();
    final orderAdapter = SupabaseOrderAdapter();
    final storageAdapter = SharedPrefsAdapter();
    final cartRemoteAdapter = SupabaseCartAdapter();
    final addressAdapter = SupabaseAddressAdapter();

    Get.put<LocalStorageRepository>(storageAdapter, permanent: true);
    Get.put<AddressRepository>(addressAdapter, permanent: true);

    final loginUseCase = LoginUseCase(authAdapter, storageAdapter);
    final registerUseCase = RegisterUseCase(authAdapter);
    final getProductsUseCase = GetProductsUseCase(productAdapter);
    final searchProductsUseCase = SearchProductsUseCase();
    final createOrderUseCase = CreateOrderUseCase(orderAdapter, productAdapter);
    final toggleFavoriteUseCase = ToggleFavoriteUseCase(productAdapter, storageAdapter);

    Get.put(AuthController(loginUseCase, registerUseCase, authAdapter), permanent: true);
    Get.put(ProductController(getProductsUseCase, toggleFavoriteUseCase, searchProductsUseCase, productAdapter, storageAdapter), permanent: true);
    Get.put(CartController(storageAdapter, cartRemoteAdapter), permanent: true);
    Get.put(OrderController(createOrderUseCase, orderAdapter, storageAdapter, addressAdapter), permanent: true);
  }
}
