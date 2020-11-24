import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:duyvo/utils/constants.dart';
import 'package:duyvo/utils/local_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

part 'authencation_event.dart';
part 'authencation_state.dart';

class AuthencationBloc extends Bloc<AuthencationEvent, AuthencationState> {
  AuthencationBloc() : super(AuthencationInitial());
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
            final LoginResult result = await FacebookAuth.instance.login();

            final FacebookAuthCredential facebookAuthCredential =
                FacebookAuthProvider.credential(result.accessToken.token);

            var userCredential = await FirebaseAuth.instance
                .signInWithCredential(facebookAuthCredential);
            yield AuthenticationAuthenticated(user: userCredential.user);
          } else if (user != null && pass != null && loginMethod != null) {
            if (loginMethod == Constants.LOGIN_WITH_EMAIL) {
              UserCredential userCredential =
                  await firebaseAuth.signInWithEmailAndPassword(
                email: user,
                password: pass,
              );
              yield AuthenticationAuthenticated(user: userCredential.user);
            } else if (loginMethod == Constants.LOGIN_WITH_PHONE) {
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
        yield AuthenticationUnauthenticated();
      } catch (e) {
        yield AuthenticationUnauthenticated();
      }
    }
  }
}
