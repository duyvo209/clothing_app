import 'package:duyvo/models/Collection.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();

  // final Collection collection;
  // CollectionPage({@required this.collection});
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Collection",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              GridView.count(
                  physics: ClampingScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: 1 / 1.25,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: collections.map((collection) {
                    return Image(
                      image: AssetImage(collection.image),
                      fit: BoxFit.cover,
                    );
                  }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
