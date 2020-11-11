import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/models/Product.dart';
import 'package:duyvo/pages/DetailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  String _searchString = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            if (_searchString.isEmpty)
              Center(
                child: Container(
                  child: Text(
                    "",
                  ),
                ),
              )
            else
              FutureBuilder<QuerySnapshot>(
                future: _firebaseServices.productsRef
                    .orderBy("search_string")
                    .startAt([_searchString]).endAt(
                        ["$_searchString\uf8ff"]).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text("Error: ${snapshot.error}"),
                      ),
                    );
                  }

                  // Collection Data ready to display
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Display the data inside a list view
                    return snapshot.data.size > 0
                        ? ListView(
                            padding: EdgeInsets.only(
                              top: 128.0,
                              bottom: 12.0,
                            ),
                            children: snapshot.data.docs.map((document) {
                              return SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      GridView.count(
                                        physics: ClampingScrollPhysics(),
                                        crossAxisCount: 1,
                                        shrinkWrap: true,
                                        childAspectRatio: 1 / 0.65,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailPage(
                                                            product: Product
                                                                .fromFireStore(
                                                                    document
                                                                        .data()),
                                                          )));
                                            },
                                            child: Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: Hero(
                                                    tag: document.data()['img'],
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "https://drive.google.com/thumbnail?id=${document.data()['img']}&sz=w200-h200",
                                                    ),
                                                  )),
                                                  Text(document.data()['name']),
                                                  Text(
                                                    "${document.data()['price']}\$",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ]),
                              );
                            }).toList(),
                          )
                        : Center(child: Text("Not found"));
                  }
                  // Loading State
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.only(
                top: 45.0,
              ),
              child: CustomInput(
                hintText: "Search products...",
                onSubmitted: (value) {
                  setState(() {
                    _searchString = value.toLowerCase();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("products");

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
}

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  CustomInput(
      {this.hintText,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPasswordField});

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(12.0)),
      child: TextField(
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        autofocus: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText ?? "Hint Text...",
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
