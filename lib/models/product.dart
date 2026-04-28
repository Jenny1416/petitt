class Product {
  final String id, name, brand, category, image, description;
  final double price, oldPrice, rating;
  final int discount;
  int stock;
  final List<String> tags;
  Product(
      {required this.id,
      required this.name,
      required this.brand,
      required this.category,
      required this.price,
      required this.oldPrice,
      required this.discount,
      required this.rating,
      required this.stock,
      required this.image,
      required this.description,
      required this.tags});
  factory Product.fromJson(Map<String, dynamic> j) => Product(
      id: j['id'],
      name: j['name'],
      brand: j['brand'],
      category: j['category'],
      price: (j['price'] as num).toDouble(),
      oldPrice: (j['oldPrice'] as num).toDouble(),
      discount: j['discount'],
      rating: (j['rating'] as num).toDouble(),
      stock: j['stock'],
      image: j['image'],
      description: j['description'],
      tags: List<String>.from(j['tags']));
}
