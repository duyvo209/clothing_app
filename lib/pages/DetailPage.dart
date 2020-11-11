import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/blocs/login/login_bloc.dart';
import 'package:duyvo/blocs/products/products_bloc.dart';
import 'package:duyvo/models/Product.dart';
import 'package:duyvo/pages/CartPage.dart';
import 'package:duyvo/pages/LoginPage.dart';
import 'package:duyvo/pages/RadioSize.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart';

enum SizeType { S, M, L }

class DetailPage extends StatefulWidget {
  final Product product;

  DetailPage({@required this.product});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var currentSize = SizeType.S;

  int _count = 1;

  void _add() {
    setState(() {
      _count++;
    });
  }

  void _minus() {
    setState(() {
      if (_count > 1) {
        _count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "${widget.product.productName}",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            Badge(
              badgeContent: Text(
                _count.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              badgeColor: Colors.red[600],
              shape: BadgeShape.circle,
              position: BadgePosition.topStart(start: 25, top: 2.5),
              animationType: BadgeAnimationType.scale,
              child: IconButton(
                icon: Icon(EvaIcons.shoppingCartOutline),
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new CartPage()));
                },
              ),
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: widget.product.image,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://drive.google.com/thumbnail?id=${widget.product.image}&sz=w500-h500",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  child: Text(
                    "${widget.product.productName}",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  child: Text(
                    "${widget.product.price}\$",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Row(
                    children: <Widget>[
                      RadioSize(
                          value: SizeType.S,
                          groupValue: currentSize,
                          onChanged: (value) {
                            setState(() {
                              currentSize = value;
                            });
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      RadioSize(
                          value: SizeType.M,
                          groupValue: currentSize,
                          onChanged: (value) {
                            setState(() {
                              currentSize = value;
                            });
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      RadioSize(
                          value: SizeType.L,
                          groupValue: currentSize,
                          onChanged: (value) {
                            setState(() {
                              currentSize = value;
                            });
                          }),
                      Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _minus();
                            },
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                EvaIcons.minusOutline,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              _count.toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _add();
                            },
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton.icon(
                          color: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          textColor: Colors.black,
                          icon: Icon(EvaIcons.shoppingBagOutline),
                          label: Text("Cart"),
                          onPressed: () async {
                            var user =
                                BlocProvider.of<LoginBloc>(context).state.user;
                            if (user != null) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection("cart")
                                  .add({
                                "product": widget.product.toMap(),
                                "quantity": _count,
                                "size": currentSize.index,
                                // "name": widget.product.productName,
                              });
                            } else {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new LoginPage()));
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RaisedButton.icon(
                            textColor: Colors.white70,
                            color: Colors.blueGrey[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            icon: Icon(EvaIcons.creditCard),
                            label: Text("Buy Now"),
                            onPressed: () {}),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  // child: Text(
                  //   product.description,
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
