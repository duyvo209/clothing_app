part of 'tshirt_bloc.dart';

class TshirtState extends Equatable {
  final List<Product> products;

  TshirtState({this.products});

  factory TshirtState.empty() {
    return TshirtState(products: []);
  }

  TshirtState copyWith(List<Product> products) {
    return TshirtState(products: products ?? this.products);
  }

  @override
  List<Object> get props => [this.products];
}

class TshirtInitial extends TshirtState {}
