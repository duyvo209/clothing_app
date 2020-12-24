import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'login_phone_event.dart';
part 'login_phone_state.dart';

class LoginPhoneBloc extends Bloc<LoginPhoneEvent, LoginPhoneState> {
  LoginPhoneBloc() : super(LoginPhoneState.empty());
  FirebaseAuth _auth = FirebaseAuth.instance;
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
            codeSent: (String verificationId,
                [int forceResendingToken]) async* {
              print(verificationId);
              yield state.copyWith(verificationId: verificationId);
            },
            codeAutoRetrievalTimeout: (code) {});
        yield state.copyWith(
          loginPhoneLoading: false,
        );
      } catch (e) {
        yield state.copyWith(
          loginPhoneError: e.toString(),
          loginPhoneLoading: false,
        );
        // yield state.copyWith(
        //   loginPhoneError: '',
        //   loginPhoneLoading: false,
        //   loginPhoneSuccess: false,
        // );
      }
    }
    if (event is VerifyCode) {
      try {
        yield state.copyWith(
          confirmCodeLoading: true,
        );

        AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: state.verificationId, smsCode: event.code);

        UserCredential result = await _auth.signInWithCredential(credential);
        yield state.copyWith(
          confirmCodeLoading: false,
          userId: result.user.uid,
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
        confirmCodeLoading: false,
        confirmCodeSuccess: false,
      );
    }
  }
}
