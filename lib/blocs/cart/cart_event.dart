part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class GetListCart extends CartEvent {
  final String userId;

  GetListCart(this.userId);
}

class ClearAllCart extends CartEvent {
  final String userId;

  ClearAllCart(this.userId);
}
