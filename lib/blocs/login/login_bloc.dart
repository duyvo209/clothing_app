import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.empty());
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Login) {
      try {
        yield state.copyWith(
          loginLoading: true,
          loginError: '',
          loginSuccess: false,
        );
        var result = await firebaseAuth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        if (result != null) {
          yield state.copyWith(
              loginLoading: false, loginSuccess: true, user: result.user);
        }
      } on FirebaseAuthException catch (e) {
        yield state.copyWith(
          loginError: e.message,
          loginLoading: false,
          loginSuccess: false,
        );
      }
    }
    if (event is LogOut) {
      try {
        yield state.copyWith(
          logoutLoading: true,
        );
        await firebaseAuth.signOut();
        yield state.copyWithUser(null);
      } catch (e) {
        yield state.copyWith(
          logoutLoading: false,
        );
      }
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }
}
