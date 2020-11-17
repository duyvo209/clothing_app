import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/blocs/login/login_bloc.dart';
import 'package:duyvo/blocs/tshirts/tshirt_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:duyvo/pages/DetailPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CartPage.dart';

class TShirtPage extends StatefulWidget {
  @override
  _TShirtPageState createState() => _TShirtPageState();
}

class _TShirtPageState extends State<TShirtPage> {
  var user;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TshirtBloc>(context).add(
      GetListTShirt(),
    );
    user = BlocProvider.of<LoginBloc>(context).state.user;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TshirtBloc, TshirtState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "DuyVo",
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
                                          builder: (context) =>
                                              new CartPage()));
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
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here ...",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "T-Shirts",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GridView.count(
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 1 / 1.25,
                    children: state.products.map((product) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  product: product,
                                ),
                              ));
                        },
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Hero(
                                  tag: product.image,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://drive.google.com/thumbnail?id=${product.picture[0]}&sz=w200-h200",
                                  ),
                                ),
                              ),
                              Text(
                                "${product.productName}",
                              ),
                              Text(
                                "${product.price}\$",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
