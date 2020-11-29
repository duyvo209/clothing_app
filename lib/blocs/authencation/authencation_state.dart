part of 'authencation_bloc.dart';

class AuthencationState extends Equatable {
  final List<Cart> cart;

  AuthencationState({this.cart});

  factory AuthencationState.empty() {
    return AuthencationState(cart: []);
  }

  @override
  List<Object> get props => [this.cart];
}

class AuthencationInitial extends AuthencationState {}

class AuthencationLoading extends AuthencationState {}

class AuthenticationAuthenticated extends AuthencationState {
  final User user;

  AuthenticationAuthenticated({this.user});
  @override
  List<Object> get props => [user];
}

class AuthenticationUnVerifyPhone extends AuthencationState {
  @override
  List<Object> get props => ['AuthenticationUnVerifyPhone'];
}

class AuthenticationUnauthenticated extends AuthencationState {
  @override
  List<Object> get props => ['AuthenticationUnauthenticated'];
}
