import 'package:duyvo/blocs/login/login_bloc.dart';
import 'package:duyvo/blocs/yourorder/yourorder_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:expandable/expandable.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var user;
  @override
  void initState() {
    super.initState();

    user = BlocProvider.of<LoginBloc>(context).state.user;
    BlocProvider.of<YourorderBloc>(context).add(
      GetListOrder(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YourorderBloc, YourorderState>(
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
              IconButton(
                icon: Icon(EvaIcons.shoppingCartOutline),
                onPressed: () {},
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
                    "Your Orders".tr().toString(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView(
                  children: List.generate(state.order.length, (index) {
                    var order = state.order[index];
                    var products = order.carts;

                    if (user != null) {
                      return ExpandablePanel(
                        header: Container(
                          child: Text(
                            "${order.idOrder}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blueGrey[600],
                              height: 2.4,
                            ),
                          ),
                          height: 50,
                        ),
                        expanded: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: EdgeInsets.only(left: 36.0, right: 36.0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Order Date".tr().toString() +
                                              ": ${DateFormat('dd-MM-yyyy  hh:mm').format(order.dateTime)}",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Products".tr().toString() + ":",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                  children: List.generate(products.length, (i) {
                                var cart = products[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "${cart.product.productName} (${cart.quantity})",
                                            textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Total".tr().toString() + " ${order.total}\$",
                                  textAlign: TextAlign.center),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Status".tr().toString() +
                                      ": ${order.status}",
                                  textAlign: TextAlign.center),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
