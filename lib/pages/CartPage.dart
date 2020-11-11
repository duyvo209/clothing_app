import 'dart:ui';
import 'package:duyvo/blocs/cart/cart_bloc.dart';
import 'package:duyvo/blocs/login/login_bloc.dart';
import 'package:duyvo/blocs/order/order_bloc.dart';
import 'package:duyvo/models/Cart.dart';
import 'package:duyvo/pages/OrderPage.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

double getTotalPrice(List<Cart> carts) {
  return carts
      .map((e) => e.quantity * double.tryParse(e.product.price))
      .toList()
      .reduce((value, element) => value + element);
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var user;

  int _count = 0;

  String _convertSizeToString(int size) {
    if (size == 0) {
      return "S";
    } else if (size == 1) {
      return "M";
    } else if (size == 2) {
      return "L";
    } else {
      return "";
    }
  }

  Future<void> deleteCart(String productId) async {
    try {
      var user = BlocProvider.of<LoginBloc>(context).state.user;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId)
          .delete();
      BlocProvider.of<CartBloc>(context).add(
        GetListCart(user.uid),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> changeQuantity(int quantity, String productId) async {
    try {
      var user = BlocProvider.of<LoginBloc>(context).state.user;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId)
          .update({'quantity': quantity});
      BlocProvider.of<CartBloc>(context).add(
        GetListCart(user.uid),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  String fullname = '';
  String phone = '';
  String address = '';

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<LoginBloc>(context).state.user;
    if (user != null) {
      BlocProvider.of<CartBloc>(context).add(
        GetListCart(user.uid),
      );
    }

    _phoneController.addListener(() {
      setState(() {
        phone = _phoneController.text;
      });
    });
    _addressController.addListener(() {
      setState(() {
        address = _addressController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
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
            IconButton(
              icon: Icon(EvaIcons.fileTextOutline),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new OrderPage()));
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Shopping Cart",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                    children: List.generate(state.cart.length, (index) {
                  if (user != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        // color: Colors.grey[300],
                                        ),
                                    child: Center(
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.scaleDown,
                                                image: NetworkImage(
                                                    "https://drive.google.com/thumbnail?id=${state.cart[index].product.image}")),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          child: Text(
                                              '${state.cart[index].product.productName}' +
                                                  ' (' +
                                                  _convertSizeToString(
                                                      state.cart[index].size) +
                                                  ')'),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (state.cart[index]
                                                          .quantity >
                                                      1) {
                                                    changeQuantity(
                                                        (state.cart[index]
                                                                .quantity -
                                                            1),
                                                        state.cart[index]
                                                            .idCart);
                                                  }
                                                });
                                                //
                                              },
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Icon(
                                                  EvaIcons.minusOutline,
                                                  color: Colors.black,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                (state.cart[index].quantity +
                                                        _count)
                                                    .toString(),
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await changeQuantity(
                                                    state.cart[index].quantity +
                                                        1,
                                                    state.cart[index].idCart);
                                              },
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.blueGrey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.black,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${int.parse(state.cart[index].product.price) * state.cart[index].quantity}\$',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            // caption: 'More',
                            color: Colors.black45,
                            // icon: Icons.more_horiz,
                            iconWidget: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 30,
                            ),
                            onTap: () {},
                          ),
                          IconSlideAction(
                              // caption: 'Delete',
                              color: Colors.red,
                              // icon: Icons.delete,
                              iconWidget: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                              onTap: () async {
                                await deleteCart(state.cart[index].idCart);
                              }),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                })),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, -15),
                  blurRadius: 20,
                  color: Color(0xFFDADADA) //.withOpacity(0.15),
                  ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Total:\n",
                        style: TextStyle(fontSize: 15),
                        children: [
                          if (state.cart.isNotEmpty)
                            if (user != null)
                              TextSpan(
                                text:
                                    "${state.cart.map((e) => e.quantity * double.tryParse(e.product.price)).toList().reduce((value, element) => value + element).toStringAsFixed(0)}\$",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                          if (state.cart.isEmpty)
                            if (user == null)
                              TextSpan(
                                text: "",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 140,
                    ),
                    SizedBox(
                      width: 180,
                      height: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          if (state.cart.isNotEmpty) {
                            _onButton(state.cart);
                          }
                        },
                        textColor: Colors.white,
                        color: Colors.blueGrey[800],
                        child: Text(
                          'Check Out',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _onButton(List<Cart> carts) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child:
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                if (state.user != null) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(state.user.uid)
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.data != null) {
                          Map<String, dynamic> data = snapshot.data.data();
                          final initName =
                              "${data['lastname']} ${data['firstname']}";
                          _fullnameController.text = initName;
                          // print('current data:: $initName $data');
                          return BlocBuilder<CartBloc, CartState>(
                              builder: (context, state) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, -15),
                                    blurRadius: 20,
                                    color: Color(0xFFDADADA).withOpacity(0.15),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Check Out",
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "Total: ",
                                      style: TextStyle(fontSize: 15),
                                      children: [
                                        if (state.cart.isNotEmpty)
                                          TextSpan(
                                            text:
                                                "${getTotalPrice(carts).toStringAsFixed(0)}\$",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        if (state.cart.isEmpty)
                                          TextSpan(
                                            text: "",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: _fullnameController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Full Name",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: _phoneController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Phone Number",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: TextField(
                                      controller: _addressController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Address",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  BlocListener<OrderBloc, OrderState>(
                                    listener: (context, state) {
                                      if (state.orderSuccess == true) {
                                        BlocProvider.of<CartBloc>(context).add(
                                          ClearAllCart(user.uid),
                                        );
                                      }
                                      // if(state.orderSuccess == false) {

                                      // }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 150,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<OrderBloc>(context)
                                              .add(
                                            NewOrderEvent(
                                              fullname:
                                                  _fullnameController.text,
                                              phone: _phoneController.text,
                                              address: _addressController.text,
                                              carts: carts,
                                              userId: user.uid,
                                            ),
                                          );

                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new OrderPage()));
                                        },
                                        textColor: Colors.white,
                                        color: Colors.blueGrey[800],
                                        child: Text(
                                          'BUY',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              height: 500,
                            );
                          });
                        } else {
                          return Container();
                        }
                      });
                }
                return Container();
              }),
            ),
          );
        });
  }
}
