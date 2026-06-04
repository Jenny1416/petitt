import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../domain/models/product.dart';
import '../../../domain/models/review.dart';
import '../../../domain/ports/product_repository.dart';

class JsonProductAdapter implements ProductRepository {
  List<Product>? _cachedProducts;

  @override
  Future<List<Product>> getProducts() async {
    if (_cachedProducts != null) return _cachedProducts!;
    
    final data = await rootBundle.loadString('assets/data/products.json');
    final list = jsonDecode(data) as List;
    _cachedProducts = list.map((e) => Product.fromJson(e)).toList();
    return _cachedProducts!;
  }

  @override
  Future<void> addReview(String productId, ReviewModel review) async {
    final products = await getProducts();
    final product = products.firstWhere((p) => p.id == productId);
    product.reviews.add(review);
    
    // Recalcular rating
    double totalStars = product.reviews.fold(0.0, (prev, element) => prev + element.rating);
    product.rating = totalStars / product.reviews.length;
  }

  @override
  Future<void> updateStock(String productId, int quantity) async {
    final products = await getProducts();
    final product = products.firstWhere((p) => p.id == productId);
    product.stock -= quantity;
  }
}
