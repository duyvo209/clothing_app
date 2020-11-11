import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/models/Product.dart';

part 'tshirt_event.dart';
part 'tshirt_state.dart';

class TshirtBloc extends Bloc<TshirtEvent, TshirtState> {
  TshirtBloc() : super(TshirtState.empty());
  @override
  Stream<TshirtState> mapEventToState(
    TshirtEvent event,
  ) async* {
    if (event is GetListTShirt) {
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
            .where((element) => element.type == 'tshirt')
            .toList();
        yield state.copyWith(listProduct);
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
