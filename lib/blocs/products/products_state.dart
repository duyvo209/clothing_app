part of 'products_bloc.dart';

class ProductsState extends Equatable {
  final List<Product> products;

  ProductsState({this.products});

  factory ProductsState.empty() {
    return ProductsState(products: []);
  }

  ProductsState copyWith(List<Product> products) {
    return ProductsState(products: products ?? this.products);
  }

  @override
  List<Object> get props => [this.products];
}

class ProductsInitial extends ProductsState {}
