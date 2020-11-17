import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';

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

  int _selectedPage = 0;

  var user;
  var cart;

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

  GlobalKey<ScaffoldState> showSnackBar = GlobalKey();

  final SnackBar _snackBar = SnackBar(
    content: Text(
      "Product added to the cart",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 1),
  );

  @override
  void initState() {
    user = BlocProvider.of<LoginBloc>(context).state.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
      return Scaffold(
        key: showSnackBar,
        appBar: AppBar(
          centerTitle: true,
          title: AutoSizeText(
            "${widget.product.productName}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            maxLines: 1,
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            user != null
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('cart')
                        .snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.data != null) {
                        int quantity = snapshot.data.docs.length;
                        if (quantity != 0) {
                          return Badge(
                            badgeContent: Text(
                              "$quantity",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            badgeColor: Colors.red[600],
                            shape: BadgeShape.circle,
                            position:
                                BadgePosition.topStart(start: 25, top: 2.5),
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
                          );
                        } else {
                          return IconButton(
                            icon: Icon(EvaIcons.shoppingCartOutline),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new CartPage()));
                            },
                          );
                        }
                      }
                      return Container();
                    })
                : IconButton(
                    icon: Icon(EvaIcons.shoppingCartOutline),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new CartPage()));
                    },
                  ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Container(
              height: 400,
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PageView(
                    onPageChanged: (num) {
                      setState(() {
                        _selectedPage = num;
                      });
                    },
                    children: [
                      for (var i = 0; i < widget.product.picture.length; i++)
                        Container(
                          child: Hero(
                            tag: widget.product.image,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://drive.google.com/thumbnail?id=${widget.product.picture[i]}&sz=w500-h500",
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  Positioned(
                    bottom: 20.0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < widget.product.picture.length; i++)
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            width: _selectedPage == i ? 30.0 : 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                                // color: Colors.black.withOpacity(0.2),
                                color: _selectedPage == i
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
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
                  fontSize: 24,
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
                    child: GestureDetector(
                      onTap: () async {
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
                          });
                          showSnackBar.currentState.showSnackBar(_snackBar);
                        } else {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new LoginPage()));
                        }
                      },
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Add To Cart".tr().toString(),
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
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
                        label: Text("Buy Now".tr().toString()),
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
              child: Text(
                "${widget.product.description}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }
}
