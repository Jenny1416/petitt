import 'review.dart';

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

  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      id: j['id']?.toString() ?? '',
      name: j['name']?.toString() ?? 'Producto sin nombre',
      brand: j['brand']?.toString() ?? '',
      category: j['category']?.toString() ?? '',
      type: j['type']?.toString() ?? 'Accesorio',
      price: double.tryParse(j['price']?.toString() ?? '0') ?? 0.0,
      oldPrice: double.tryParse(j['old_price']?.toString() ?? j['oldPrice']?.toString() ?? '0') ?? 0.0,
      discount: int.tryParse(j['discount']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(j['rating']?.toString() ?? '0') ?? 0.0,
      stock: int.tryParse(j['stock']?.toString() ?? '0') ?? 0,
      image: j['image_url']?.toString() ?? j['image']?.toString() ?? '',
      description: j['description']?.toString() ?? '',
      tags: j['tags'] != null ? List<String>.from(j['tags']) : [],
      reviews: (j['reviews'] != null && j['reviews'] is List)
          ? (j['reviews'] as List).map((r) => ReviewModel.fromJson(r)).toList() 
          : [],
    );
  }

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
