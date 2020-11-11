import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/models/Product.dart';
import 'package:equatable/equatable.dart';
part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsState.empty());

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is GetListProduct) {
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
