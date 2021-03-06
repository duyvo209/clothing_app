import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Product extends Equatable {
  final String productName;
  final String image;
  final String price;
  final String quantity;
  final String type;
  final String description;
  final int id;
  final List<dynamic> picture;

  Product({
    @required this.quantity,
    @required this.type,
    @required this.description,
    @required this.id,
    @required this.image,
    @required this.price,
    @required this.productName,
    @required this.picture,
  });

  factory Product.fromFireStore(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      image: json['img'],
      productName: json['name'],
      price: json['price'].toString(),
      quantity: json['quantity'].toString(),
      type: json['type'],
      description: json['description'],
      picture: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "img": image,
      "name": productName,
      "price": price,
      "quantity": quantity,
      "type": type,
    };
  }

  @override
  List<Object> get props => [
        this.id,
        this.productName,
        this.price,
        this.image,
        this.quantity,
        this.type,
        this.description,
        this.picture
      ];
}
