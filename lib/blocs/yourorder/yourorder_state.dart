part of 'yourorder_bloc.dart';

class YourorderState extends Equatable {
  final List<Order> order;
  YourorderState({this.order});

  factory YourorderState.empty() {
    return YourorderState(order: []);
  }

  YourorderState copyWith(List<Order> order) {
    return YourorderState(order: order ?? this.order);
  }

  @override
  List<Object> get props => [this.order];
}

class YourorderInitial extends YourorderState {}
