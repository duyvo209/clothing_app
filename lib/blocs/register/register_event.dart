part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class Register extends RegisterEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String imageUser;

  Register(
      {@required this.firstname,
      @required this.lastname,
      @required this.email,
      @required this.password,
      @required this.imageUser});
}
