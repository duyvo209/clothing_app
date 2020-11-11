import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:duyvo/models/Cart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.empty());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is GetListCart) {
      try {
        var data = await FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .collection('cart')
            .snapshots()
            .first;
        // print(data);
        var listCart = data.docs.map((e) {
          var cart = Cart.fromFireStore(e.data());
          var idCart = e.id;
          cart.setCartId(idCart);
          return cart;
        }).toList();
        yield state.copyWith(listCart);
      } catch (e) {
        print(e.toString());
      }
    }

    if (event is ClearAllCart) {
      var listCarts = await FirebaseFirestore.instance
          .collection('users')
          .doc(event.userId)
          .collection('cart')
          .get();
      listCarts.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .collection('cart')
            .doc(element.id)
            .delete();
      });
      add(GetListCart(event.userId));
    }
  }
}
