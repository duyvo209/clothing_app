part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {}

class NewOrderEvent extends OrderEvent {
  final String fullname;
  final String phone;
  final String address;
  final String userId;
  final List<Cart> carts;

  NewOrderEvent({
    @required this.fullname,
    @required this.phone,
    @required this.address,
    this.carts,
    this.userId,
  });

  @override
  List<Object> get props => [fullname, carts, phone, address];

  // String toString() => '$runtimeType $props';

  Order toOrder() {
    return Order.newOrder(
      address: address,
      carts: carts,
      name: fullname,
      phone: phone,
      userId: userId,
      total: getTotalPrice(carts).toStringAsFixed(0),
    );
  }
}
