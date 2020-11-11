part of 'jeans_bloc.dart';

class JeansState extends Equatable {
  final List<Product> products;

  JeansState({this.products});

  factory JeansState.empty() {
    return JeansState(products: []);
  }

  JeansState copyWith(List<Product> products) {
    return JeansState(products: products ?? this.products);
  }

  @override
  List<Object> get props => [];
}

class JeansInitial extends JeansState {}
