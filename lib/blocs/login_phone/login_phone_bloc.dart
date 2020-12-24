import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/utils/local_storage.dart';
import 'package:duyvo/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:duyvo/blocs/authencation/authencation_bloc.dart';
part 'login_phone_event.dart';
part 'login_phone_state.dart';

class LoginPhoneBloc extends Bloc<LoginPhoneEvent, LoginPhoneState> {
  LoginPhoneBloc(this.authencationBloc) : super(LoginPhoneState.empty());
  FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthencationBloc authencationBloc;
  String verificationId = '';
  @override
  Stream<LoginPhoneState> mapEventToState(
    LoginPhoneEvent event,
  ) async* {
    if (event is LoginPhone) {
      try {
        yield state.copyWith(
          loginPhoneLoading: true,
        );
        await _auth.verifyPhoneNumber(
            phoneNumber: event.phoneNumber,
            verificationCompleted: (credential) {
              print('completed');
            },
            verificationFailed: (error) async* {
              yield state.copyWith(
                loginPhoneError: error.message,
                confirmCodeLoading: false,
              );
            },
            codeSent: (String verificationId, [int forceResendingToken]) {
              print(verificationId);
              this.verificationId = verificationId;
            },
            codeAutoRetrievalTimeout: (code) {});
        yield state.copyWith(
          loginPhoneSuccess: true,
          loginPhoneLoading: false,
        );
      } catch (e) {
        yield state.copyWith(
          loginPhoneError: e.toString(),
          loginPhoneLoading: false,
        );
      }
      yield state.copyWith(
        loginPhoneError: '',
        loginPhoneLoading: false,
        loginPhoneSuccess: false,
      );
    }
    if (event is VerifyCode) {
      try {
        yield state.copyWith(
          confirmCodeLoading: true,
        );

        AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: event.code);

        UserCredential result = await _auth.signInWithCredential(credential);
        var document = await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user.uid)
            .get();

        if (document.exists) {
          await LocalStorage().setLoginMethod(Constants.LOGIN_WITH_PHONE);
          authencationBloc.add(LoggedIn());
        } else {
          yield state.copyWith(userId: result.user.uid);
        }
        yield state.copyWith(
          confirmCodeLoading: false,
          confirmCodeSuccess: true,
        );
      } catch (e) {
        yield state.copyWith(
          cofirmCodeError: e.toString(),
          confirmCodeLoading: false,
        );
      }
      yield state.copyWith(
        cofirmCodeError: '',
        userId: '',
        confirmCodeLoading: false,
        confirmCodeSuccess: false,
      );
    }
  }
}
