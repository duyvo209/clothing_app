import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState.empty());
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is Register) {
      try {
        yield state.copyWith(
          registerLoading: true,
          registerError: '',
          registerSuccess: false,
        );
        var user = await firebaseAuth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        if (user != null) {
          await fireStore.collection('users').doc(user.user.uid).set({
            'firstname': event.firstname,
            'lastname': event.lastname,
            'email': event.email,
          });
          yield state.copyWith(registerLoading: false, registerSuccess: true);
        }
      } catch (e) {
        yield state.copyWith(
          registerError: e.toString(),
          registerLoading: false,
          registerSuccess: false,
        );
      }
    }
  }
}
