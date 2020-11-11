import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/models/Product.dart';
import 'package:duyvo/pages/DetailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
                    "Search Results",
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
                hintText: "Search here...",
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
  // FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("products");

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
}

// class ProductCard extends StatelessWidget {
//   final String productId;
//   final Function onPressed;
//   final String imageUrl;
//   final String title;
//   final String price;
//   ProductCard(
//       {this.onPressed, this.imageUrl, this.title, this.price, this.productId});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProductPage(
//                 productId: productId,
//               ),
//             ));
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         height: 350.0,
//         margin: EdgeInsets.symmetric(
//           vertical: 12.0,
//           horizontal: 24.0,
//         ),
//         child: Stack(
//           children: [
//             Container(
//               height: 350.0,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12.0),
//                 child: Image.network(
//                   "$imageUrl",
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       title,
//                     ),
//                     Text(
//                       price,
//                       style: TextStyle(
//                           fontSize: 18.0,
//                           color: Theme.of(context).accentColor,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProductPage extends StatefulWidget {
//   final String productId;
//   ProductPage({this.productId});

//   @override
//   _ProductPageState createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   FirebaseServices _firebaseServices = FirebaseServices();
//   String _selectedProductSize = "0";

//   Future _addToCart() {
//     return _firebaseServices.usersRef
//         .doc(_firebaseServices.getUserId())
//         .collection("Cart")
//         .doc(widget.productId)
//         .set({"size": _selectedProductSize});
//   }

//   Future _addToSaved() {
//     return _firebaseServices.usersRef
//         .doc(_firebaseServices.getUserId())
//         .collection("Saved")
//         .doc(widget.productId)
//         .set({"size": _selectedProductSize});
//   }

//   final SnackBar _snackBar = SnackBar(
//     content: Text("Product added to the cart"),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FutureBuilder(
//             future: _firebaseServices.productsRef.doc(widget.productId).get(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Scaffold(
//                   body: Center(
//                     child: Text("Error: ${snapshot.error}"),
//                   ),
//                 );
//               }

//               if (snapshot.connectionState == ConnectionState.done) {
//                 // Firebase Document Data Map
//                 Map<String, dynamic> documentData = snapshot.data.data();

//                 // List of images
//                 List imageList = documentData['images'];
//                 List productSizes = documentData['size'];

//                 // Set an initial size
//                 _selectedProductSize = productSizes[0];

//                 return ListView(
//                   padding: EdgeInsets.all(0),
//                   children: [
//                     ImageSwipe(
//                       imageList: imageList,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 24.0,
//                         left: 24.0,
//                         right: 24.0,
//                         bottom: 4.0,
//                       ),
//                       child: Text(
//                         "${documentData['name']}",
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 4.0,
//                         horizontal: 24.0,
//                       ),
//                       child: Text(
//                         "\$${documentData['price']}",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           color: Theme.of(context).accentColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 8.0,
//                         horizontal: 24.0,
//                       ),
//                       child: Text(
//                         "${documentData['desc']}",
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 24.0,
//                         horizontal: 24.0,
//                       ),
//                       child: Text(
//                         "Select Size",
//                       ),
//                     ),
//                     ProductSize(
//                       productSizes: productSizes,
//                       onSelected: (size) {
//                         _selectedProductSize = size;
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           GestureDetector(
//                             onTap: () async {
//                               await _addToSaved();
//                               Scaffold.of(context).showSnackBar(_snackBar);
//                             },
//                             child: Container(
//                               width: 65.0,
//                               height: 65.0,
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFDCDCDC),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               alignment: Alignment.center,
//                               child: Image(
//                                 image: AssetImage(
//                                   "assets/images/tab_saved.png",
//                                 ),
//                                 height: 22.0,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () async {
//                                 await _addToCart();
//                                 Scaffold.of(context).showSnackBar(_snackBar);
//                               },
//                               child: Container(
//                                 height: 65.0,
//                                 margin: EdgeInsets.only(
//                                   left: 16.0,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   "Add To Cart",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//               }

//               // Loading State
//               return Scaffold(
//                 body: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProductSize extends StatefulWidget {
//   final List productSizes;
//   final Function(String) onSelected;
//   ProductSize({this.productSizes, this.onSelected});

//   @override
//   _ProductSizeState createState() => _ProductSizeState();
// }

// class _ProductSizeState extends State<ProductSize> {
//   int _selected = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         left: 20.0,
//       ),
//       child: Row(
//         children: [
//           for (var i = 0; i < widget.productSizes.length; i++)
//             GestureDetector(
//               onTap: () {
//                 widget.onSelected("${widget.productSizes[i]}");
//                 setState(() {
//                   _selected = i;
//                 });
//               },
//               child: Container(
//                 width: 42.0,
//                 height: 42.0,
//                 decoration: BoxDecoration(
//                   color: _selected == i
//                       ? Theme.of(context).accentColor
//                       : Color(0xFFDCDCDC),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 4.0,
//                 ),
//                 child: Text(
//                   "${widget.productSizes[i]}",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: _selected == i ? Colors.white : Colors.black,
//                     fontSize: 16.0,
//                   ),
//                 ),
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }

// class ImageSwipe extends StatefulWidget {
//   final List imageList;
//   ImageSwipe({this.imageList});

//   @override
//   _ImageSwipeState createState() => _ImageSwipeState();
// }

// class _ImageSwipeState extends State<ImageSwipe> {
//   int _selectedPage = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 400.0,
//       child: Stack(
//         children: [
//           PageView(
//             onPageChanged: (num) {
//               setState(() {
//                 _selectedPage = num;
//               });
//             },
//             children: [
//               for (var i = 0; i < widget.imageList.length; i++)
//                 Container(
//                   child: Image.network(
//                     "${widget.imageList[i]}",
//                     fit: BoxFit.cover,
//                   ),
//                 )
//             ],
//           ),
//           Positioned(
//             bottom: 20.0,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 for (var i = 0; i < widget.imageList.length; i++)
//                   AnimatedContainer(
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.easeOutCubic,
//                     margin: EdgeInsets.symmetric(
//                       horizontal: 5.0,
//                     ),
//                     width: _selectedPage == i ? 35.0 : 10.0,
//                     height: 10.0,
//                     decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12.0)),
//                   )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

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
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText ?? "Hint Text...",
            contentPadding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            )),
      ),
    );
  }
}
