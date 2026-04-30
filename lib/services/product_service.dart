import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

/// Servicio encargado de la gestión de productos.
/// Cumple con el criterio de "Origen de los datos" al consumir un archivo JSON local.
class ProductService {
  /// Carga la lista de productos desde el archivo de activos (Uso de JSON).
  /// Retorna una lista dinámica de objetos Product (ArrayList).
  Future<List<Product>> loadProducts() async {
    // Lectura del archivo JSON integrado en el proyecto
    final data = await rootBundle.loadString('assets/data/products.json');
    // Decodificación de la cadena JSON a una estructura de datos de Dart
    final list = jsonDecode(data) as List;
    // Mapeo de la lista dinámica a objetos de tipo Product
    return list.map((e) => Product.fromJson(e)).toList();
  }
}
