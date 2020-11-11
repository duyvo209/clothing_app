import 'package:cached_network_image/cached_network_image.dart';
import 'package:duyvo/blocs/products/products_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:duyvo/pages/DetailPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsBloc>(context).add(
      GetListProduct(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search...',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Products",
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
                      return Stack(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Hero(
                                  tag: Text("AAAA"),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://drive.google.com/thumbnail?id=${product.image}&sz=w200-h200",
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                    // child: Image.network(
                                    //     "https://drive.google.com/thumbnail?id=${product.image}&sz=w200-h200"),
                                  ),
                                ),
                                Text(
                                  "${product.productName}",
                                ),
                                Text(
                                  "${product.price}\$",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        product: product,
                                      ),
                                    ));
                              },
                            ),
                          )
                        ],
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
