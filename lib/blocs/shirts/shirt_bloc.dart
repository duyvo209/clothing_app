import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/models/Product.dart';

part 'shirt_event.dart';
part 'shirt_state.dart';

class ShirtBloc extends Bloc<ShirtEvent, ShirtState> {
  ShirtBloc() : super(ShirtState.empty());

  @override
  Stream<ShirtState> mapEventToState(
    ShirtEvent event,
  ) async* {
    if (event is GetListShirt) {
      try {
        var data = await FirebaseFirestore.instance
            .collection('products')
            .orderBy('id', descending: true)
            .snapshots()
            .first;
        var listProduct = data.docs
            .map((e) {
              var product = Product.fromFireStore(e.data());
              return product;
            })
            .where((element) => element.type == 'shirt')
            .toList();
        yield state.copyWith(listProduct);
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
