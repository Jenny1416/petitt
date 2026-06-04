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

  /// Factory para crear un objeto de dominio desde Supabase o JSON local.
  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'].toString(),
        name: j['name'] ?? '',
        brand: j['brand'] ?? '',
        category: j['category'] ?? '',
        type: j['type'] ?? 'Accesorio',
        price: (j['price'] as num?)?.toDouble() ?? 0.0,
        oldPrice: (j['old_price'] as num?)?.toDouble() ?? 
                  (j['oldPrice'] as num?)?.toDouble() ?? 0.0,
        discount: j['discount'] ?? 0,
        rating: (j['rating'] as num?)?.toDouble() ?? 0.0,
        stock: j['stock'] ?? 0,
        image: j['image_url'] ?? j['image'] ?? '',
        description: j['description'] ?? '',
        tags: j['tags'] != null ? List<String>.from(j['tags']) : [],
        reviews: [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'category': category,
        'type': type,
        'price': price,
        'old_price': oldPrice,
        'discount': discount,
        'rating': rating,
        'stock': stock,
        'image_url': image,
        'description': description,
        'tags': tags,
      };
}
