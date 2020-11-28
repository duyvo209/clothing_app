part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final String userId;
  final SizeType currentSize;
  final Product product;
  final int count;

  AddToCart({this.userId, this.currentSize, this.product, this.count});
}

class GetListCart extends CartEvent {
  final String userId;

  GetListCart(this.userId);
}

class ClearAllCart extends CartEvent {
  final String userId;

  ClearAllCart(this.userId);
}
