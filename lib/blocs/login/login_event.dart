part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class Login extends LoginEvent {
  final String email;
  final String password;

  Login({@required this.email, @required this.password});
}

class LoginWithFacebook extends LoginEvent {}

class LoginWithPhoneNumber extends LoginEvent {}

class LogOut extends LoginEvent {}
