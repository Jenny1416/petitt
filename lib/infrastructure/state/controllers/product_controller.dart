import 'package:get/get.dart';
import '../../../domain/models/product.dart';
import '../../../domain/models/review.dart';
import '../../../application/products/get_products_use_case.dart';
import '../../../application/products/search_products_use_case.dart';
import '../../../application/favorites/toggle_favorite_use_case.dart';
import '../../../domain/ports/product_repository.dart';
import '../../../domain/ports/local_storage_repository.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter/material.dart';

/// CAPA DE INFRAESTRUCTURA / PRESENTACIÓN - Controlador GetX
/// Gestiona el estado de los productos y la lógica de negocio relacionada con la UI.
/// 
/// PATRÓN HEXAGONAL: Los controladores actúan como "Adaptadores de Entrada" que 
/// transforman eventos de la UI en llamadas a "Casos de Uso".
class ProductController extends GetxController {
  // Casos de Uso inyectados (Capa de Aplicación).
  final GetProductsUseCase _getProductsUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  
  // Puertos inyectados (Capa de Dominio).
  final ProductRepository _productRepository;
  final LocalStorageRepository _localStorageRepository;

  ProductController(
    this._getProductsUseCase,
    this._toggleFavoriteUseCase,
    this._searchProductsUseCase,
    this._productRepository,
    this._localStorageRepository,
  );

  // GESTIÓN DE ESTADO (GetX):
  // '.obs' hace que estas variables sean reactivas. Los widgets 'Obx' se redibujarán
  // automáticamente cuando estos valores cambien.
  final RxList<Product> products = <Product>[].obs;
  final RxList<String> favoriteIds = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt homeTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Al inicializar el controlador, cargamos los datos desde los repositorios.
    loadProducts();
  }

  /// Carga inicial de productos y favoritos.
  /// 
  /// GETX + SHARPREFERENCES: Se recuperan los favoritos guardados previamente
  /// a través del puerto de almacenamiento local.
  Future<void> loadProducts() async {
    isLoading.value = true;
    products.value = await _getProductsUseCase.execute();
    
    // Recuperamos el usuario actual para traer sus favoritos de Supabase
    final authController = Get.find<AuthController>();
    final userId = authController.currentUser?.id;

    if (userId != null) {
      // Intentamos cargar de Supabase primero
      final remoteFavs = await _productRepository.getFavoriteIds(userId);
      if (remoteFavs.isNotEmpty) {
        favoriteIds.assignAll(remoteFavs);
        await _localStorageRepository.saveFavorites(remoteFavs);
      } else {
        favoriteIds.value = await _localStorageRepository.getFavorites();
      }
    } else {
      favoriteIds.value = await _localStorageRepository.getFavorites();
    }
    
    isLoading.value = false;
  }

  void setHomeTabIndex(int index) {
    homeTabIndex.value = index;
  }

  /// Lógica de filtrado y búsqueda delegada al caso de uso.
  List<Product> search(String q, String catOrType) {
    return _searchProductsUseCase.execute(products, q, catOrType);
  }

  /// Alterna el estado de favorito de un producto.
  /// 
  /// PATRÓN HEXAGONAL: Delega la lógica al caso de uso 'ToggleFavoriteUseCase'.
  Future<void> toggleFavorite(Product p) async {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser;

    if (user == null) {
      Get.snackbar(
        'Atención', 
        'Debes iniciar sesión para guardar favoritos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffD4933E).withOpacity(0.1),
        colorText: const Color(0xff123516),
      );
      return;
    }

    // Usamos el ID (UUID) del usuario para sincronizar con Supabase
    await _toggleFavoriteUseCase.execute(favoriteIds, p.id, user.id);

    favoriteIds.refresh();
  }

  bool isFav(Product p) => favoriteIds.contains(p.id);

  /// Añade una reseña a un producto.
  Future<void> addReview(String productId, double stars, String comment, String userName) async {
    final review = ReviewModel(
      userName: userName,
      date: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      comment: comment.isEmpty ? '¡Excelente producto!' : comment,
      rating: stars,
    );
    
    // INFRAESTRUCTURA: Persistimos la reseña (usualmente en una API o DB local).
    await _productRepository.addReview(productId, review);
    
    // Reactividad: Actualizamos el estado local inmediatamente para feedback visual.
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      products[index].reviews.add(review);
      double totalStars = products[index].reviews.fold(0.0, (prev, element) => prev + element.rating);
      products[index].rating = totalStars / products[index].reviews.length;
      products.refresh();
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
    products.refresh();
  }
}
