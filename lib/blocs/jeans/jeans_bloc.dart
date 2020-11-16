import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/models/Product.dart';
part 'jeans_event.dart';
part 'jeans_state.dart';

class JeansBloc extends Bloc<JeansEvent, JeansState> {
  JeansBloc() : super(JeansState.empty());

  @override
  Stream<JeansState> mapEventToState(
    JeansEvent event,
  ) async* {
    if (event is GetListJeans) {
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
            .where((element) => element.type == 'jeans')
            .toList();
        yield state.copyWith(listProduct);
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
