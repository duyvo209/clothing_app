import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/models/Order.dart';
import 'package:duyvo/pages/CartPage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:duyvo/models/Cart.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState.empty());

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is NewOrderEvent) {
      try {
        yield state.copyWith(
          orderLoading: true,
          orderSuccess: false,
          orderError: '',
        );

        await FirebaseFirestore.instance
            .collection('orders')
            .doc()
            .set(event.toOrder().toMap());

        yield state.copyWith(orderLoading: false, orderSuccess: true);
      } catch (e) {
        yield state.copyWith(
          orderLoading: false,
          orderSuccess: false,
          orderError: e.toString(),
        );
      }
      yield state.copyWith(
        orderLoading: false,
        orderSuccess: false,
        orderError: '',
      );
    }
  }
}
