import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  
  CartItem(this.product, {this.quantity = 1});
  
  double get total => product.price * quantity;

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    Product.fromJson(json['product']),
    quantity: json['quantity'],
  );
}
