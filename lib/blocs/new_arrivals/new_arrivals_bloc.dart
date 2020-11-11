import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:duyvo/models/Product.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'new_arrivals_event.dart';
part 'new_arrivals_state.dart';

class NewArrivalsBloc extends Bloc<NewArrivalsEvent, NewArrivalsState> {
  NewArrivalsBloc() : super(NewArrivalsState.empty());

  @override
  Stream<NewArrivalsState> mapEventToState(
    NewArrivalsEvent event,
  ) async* {
    if (event is GetListNewArrival) {
      try {
        var data = await FirebaseFirestore.instance
            .collection('products')
            .limit(8)
            .orderBy('id', descending: true)
            .snapshots()
            .first;
        var listProduct = data.docs.map((e) {
          var product = Product.fromFireStore(e.data());
          return product;
        }).toList();

        // listProduct.sort((a, b) {
        //   var id1 = int.parse(a.id);
        //   var id2 = int.parse(b.id);
        //   return id2.compareTo(id1);
        // });
        yield state.copyWith(listProduct);
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
