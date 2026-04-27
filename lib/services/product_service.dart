import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductService {
  Future<List<Product>> loadProducts() async {
    final data = await rootBundle.loadString('assets/data/products.json');
    final list = jsonDecode(data) as List;
    return list.map((e) => Product.fromJson(e)).toList();
  }
}
