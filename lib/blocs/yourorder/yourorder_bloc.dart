import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/blocs/login/login_bloc.dart';
import 'package:duyvo/models/Order.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'yourorder_event.dart';
part 'yourorder_state.dart';

class YourorderBloc extends Bloc<YourorderEvent, YourorderState> {
  YourorderBloc() : super(YourorderState.empty());

  @override
  Stream<YourorderState> mapEventToState(
    YourorderEvent event,
  ) async* {
    if (event is GetListOrder) {
      try {
        var user = BlocProvider.of<LoginBloc>(event.context).state.user;
        var data = await FirebaseFirestore.instance
            .collection('orders')
            .where("userId", isEqualTo: user.uid)
            // .orderBy("dateTime", descending: true)
            .snapshots()
            .first;

        var listOrder = data.docs.map((e) {
          var order = Order.formFireStore(e.data());
          var idOrder = e.id;
          order.setOrderId(idOrder);
          return order;
        }).toList();
        yield state.copyWith(listOrder);
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
