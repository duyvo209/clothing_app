part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<Cart> cart;
  CartState({this.cart});

  factory CartState.empty() {
    return CartState(cart: []);
  }

  CartState copyWith(List<Cart> cart) {
    return CartState(cart: cart ?? this.cart);
  }

  @override
  List<Object> get props => [this.cart];
}

class CartInitial extends CartState {}
