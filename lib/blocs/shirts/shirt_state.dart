part of 'shirt_bloc.dart';

class ShirtState extends Equatable {
  final List<Product> products;

  ShirtState({this.products});

  factory ShirtState.empty() {
    return ShirtState(products: []);
  }

  ShirtState copyWith(List<Product> products) {
    return ShirtState(products: products ?? this.products);
  }

  @override
  List<Object> get props => [];
}

class ShirtInitial extends ShirtState {}
