import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:duyvo/blocs/cart/cart_bloc.dart';
import 'package:duyvo/blocs/user/user_bloc.dart';
import 'package:duyvo/utils/constants.dart';
import 'package:duyvo/utils/local_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:duyvo/blocs/login/login_bloc.dart';

part 'authencation_event.dart';
part 'authencation_state.dart';

class AuthencationBloc extends Bloc<AuthencationEvent, AuthencationState> {
  final CartBloc cartBloc;
  final UserBloc userBloc;
  final LoginBloc loginBloc;
  AuthencationBloc(
      {@required this.cartBloc,
      @required this.userBloc,
      @required this.loginBloc})
      : super(AuthencationInitial());
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<AuthencationState> mapEventToState(
    AuthencationEvent event,
  ) async* {
    if (event is StartApp) {
      try {
        yield AuthencationLoading();
        var userInfo = await LocalStorage().getUserPass();
        String user = userInfo['user'];
        String pass = userInfo['pass'];
        String loginMethod = await LocalStorage().getLoginMethod();
        if (loginMethod != null) {
          if (loginMethod == Constants.LOGIN_WITH_FB) {
            final accessToken = await FacebookAuth.instance.isLogged;

            final FacebookAuthCredential facebookAuthCredential =
                FacebookAuthProvider.credential(accessToken.token);

            var userCredential = await FirebaseAuth.instance
                .signInWithCredential(facebookAuthCredential);
            cartBloc.add(GetListCart(userCredential.user.uid));
            userBloc.add(GetUser(userCredential.user.uid));
            yield AuthenticationAuthenticated(user: userCredential.user);
          } else if (user != null && pass != null && loginMethod != null) {
            if (loginMethod == Constants.LOGIN_WITH_EMAIL) {
              UserCredential userCredential =
                  await firebaseAuth.signInWithEmailAndPassword(
                email: user,
                password: pass,
              );
              cartBloc.add(GetListCart(userCredential.user.uid));
              userBloc.add(GetUser(userCredential.user.uid));

              yield AuthenticationAuthenticated(user: userCredential.user);
            }
          } else if (loginMethod == Constants.LOGIN_WITH_PHONE) {
            var userId = FirebaseAuth.instance.currentUser.uid;
            cartBloc.add(GetListCart(userId));
            userBloc.add(GetUser(userId));
            loginBloc.add(LoginWithPhoneNumber());
            yield AuthenticationAuthenticated(
                user: FirebaseAuth.instance.currentUser);
            // firebaseAuth.verifyPhoneNumber(
            //     phoneNumber: user,
            //     verificationCompleted: (data){
            //     },
            //     verificationFailed: null,
            //     codeSent: null,
            //     codeAutoRetrievalTimeout: null);
            // ConfirmationResult confirmationResult =
            //     await firebaseAuth.signInWithPhoneNumber(user);
            // confirmationResult.confirm(verificationCode)
          }
        } else {
          yield AuthenticationUnauthenticated();
        }
      } catch (e) {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      add(StartApp());
    }

    if (event is LoggedOut) {
      try {
        yield AuthencationLoading();
        await LocalStorage().deleteUserData();
        await FacebookAuth.instance.logOut();
        yield AuthenticationUnauthenticated();
      } catch (e) {
        yield AuthenticationUnauthenticated();
      }
    }
  }
}
