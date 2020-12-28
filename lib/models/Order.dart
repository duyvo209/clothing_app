import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/models/Cart.dart';

class Order {
  static const status_new = 0;
  final String id;
  final List<Cart> carts;
  final String total;
  final int status;
  final DateTime dateTime;
  final String name;
  final String phone;
  final String address;
  final String userId;
  String idOrder;

  Order.newOrder({
    this.id,
    this.carts,
    this.total,
    this.name,
    this.phone,
    this.address,
    this.userId,
  })  : status = status_new,
        dateTime = DateTime.now();

  Order({
    this.id,
    this.carts,
    this.total,
    this.status,
    this.dateTime,
    this.name,
    this.phone,
    this.address,
    this.userId,
  });

  factory Order.formFireStore(Map<String, dynamic> json) {
    final List rawCarts = json['carts'] ?? [];
    return Order(
        id: json['id'],
        carts: rawCarts.map((e) => Cart.fromFireStore(e)).toList(),
        total: json['total'],
        status: json['status'],
        dateTime: (json['dateTime'] as Timestamp).toDate(),
        name: json['name'],
        phone: json['phone'],
        address: json['address'],
        userId: json['userId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'carts': carts.map((e) => e.toMap()).toList(),
      'total': total,
      'status': status,
      'dateTime': dateTime,
      'name': name,
      'phone': phone,
      'address': address,
      'userId': userId,
    };
  }

  void setOrderId(String id) {
    this.idOrder = id;
  }
}
