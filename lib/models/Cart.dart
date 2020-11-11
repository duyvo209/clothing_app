import 'package:duyvo/models/Product.dart';

class Cart {
  final String price;
  final int quantity;
  final Product product;
  final int size;
  final String img;
  String idCart;
  Cart(
      {this.product,
      this.size,
      this.img,
      this.price,
      this.quantity,
      this.idCart});

  factory Cart.fromFireStore(Map<String, dynamic> json) {
    return Cart(
      img: json['img'],
      price: json['price'],
      quantity: json['quantity'],
      product: Product.fromFireStore(json['product']),
      size: json['size'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'quantity': quantity,
      'product': product?.toMap(),
      'size': size,
      'img': img,
    };
  }

  void setCartId(String id) {
    this.idCart = id;
  }
}
