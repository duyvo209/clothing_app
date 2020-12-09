import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:duyvo/models/Cart.dart';
import 'package:duyvo/models/Product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:duyvo/pages/DetailPage.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.empty());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is ResetStateCart) {
      yield CartState.empty();
    }
    if (event is AddToCart) {
      try {
        var query = await FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .collection('cart')
            .get();

        var listCart =
            query.docs.map((e) => Cart.fromFireStore(e.data())).toList();

        var checkSize = listCart.any((element) =>
            element.product.id == event.product.id &&
            event.currentSize.index == element.size);

        if (checkSize) {
          var path = query.docs.firstWhere((element) {
            var product = Product.fromFireStore(element.data()['product']);
            if (product.id == event.product.id) {
              return true;
            }
            return false;
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(event.userId)
              .collection('cart')
              .doc(path.id)
              .update({'quantity': path.data()['quantity'] + event.count});
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(event.userId)
              .collection('cart')
              .add({
            'product': event.product.toMap(),
            'quantity': event.count,
            'size': event.currentSize.index,
          });
        }
      } catch (e) {}
    }

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
      print('CartBloc #$hashCode');
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
