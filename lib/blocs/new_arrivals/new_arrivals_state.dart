part of 'new_arrivals_bloc.dart';

class NewArrivalsState extends Equatable {
  final List<Product> newarrivals;
  NewArrivalsState({this.newarrivals});

  factory NewArrivalsState.empty() {
    return NewArrivalsState(newarrivals: []);
  }

  NewArrivalsState copyWith(List<Product> newarrivals) {
    return NewArrivalsState(newarrivals: newarrivals ?? this.newarrivals);
  }

  @override
  List<Object> get props => [this.newarrivals];
}

class NewArrivalsInitial extends NewArrivalsState {}
