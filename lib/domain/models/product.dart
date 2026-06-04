import 'review.dart';

/// CAPA DE DOMINIO - Modelo
/// Representa la entidad de negocio 'Producto'.
/// 
/// PATRÓN HEXAGONAL: Los modelos de dominio son el corazón de la aplicación. 
/// No dependen de ninguna librería externa (como GetX o SharedPreferences) 
/// para garantizar la pureza de la lógica de negocio.
class Product {
  final String id, name, brand, category, type, image, description;
  final double price, oldPrice;
  double rating;
  final int discount;
  int stock;
  final List<String> tags;
  final List<ReviewModel> reviews; 

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.type,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.rating,
    required this.stock,
    required this.image,
    required this.description,
    required this.tags,
    List<ReviewModel>? reviews,
  }) : reviews = reviews ?? [];

  /// Factory para crear un objeto de dominio desde una estructura JSON (Infraestructura).
  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'],
        name: j['name'],
        brand: j['brand'],
        category: j['category'],
        type: j['type'] ?? 'Accesorio',
        price: (j['price'] as num).toDouble(),
        oldPrice: (j['oldPrice'] as num).toDouble(),
        discount: j['discount'],
        rating: (j['rating'] as num).toDouble(),
        stock: j['stock'],
        image: j['image'],
        description: j['description'],
        tags: List<String>.from(j['tags']),
        reviews: [],
      );
}
