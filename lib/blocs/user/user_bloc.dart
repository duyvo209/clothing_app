import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:duyvo/models/UserInfor.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState.empty());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is GetUser) {
      try {
        yield state.copyWith(
          isUserLoading: true,
          userError: '',
        );
        var result = await FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .get();
        yield state.copyWith(
            isUserLoading: false, user: UserInfor.fromFireStore(result.data()));
      } catch (e) {
        yield state.copyWith(
          isUserLoading: false,
          userError: e.toString(),
        );
      }
    }
  }
}
