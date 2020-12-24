part of 'login_phone_bloc.dart';

abstract class LoginPhoneEvent {}

class LoginPhone extends LoginPhoneEvent {
  final String phoneNumber;

  LoginPhone({@required this.phoneNumber});
}

class VerifyCode extends LoginPhoneEvent {
  final String code;

  VerifyCode({@required this.code});
}
