import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/models/Product.dart';
import 'package:duyvo/pages/DetailPage.dart';
import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:duyvo/utils/searchservice.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; i++) {
          queryResultSet.add(docs.docs[i].data());
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name']
                .toLowerCase()
                .contains(capitalizedValue.toLowerCase()) ==
            true) {
          if (element['name']
                  .toLowerCase()
                  .indexOf(capitalizedValue.toLowerCase()) ==
              0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }
      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Container(
          margin: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 4.0,
          ),
          decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12.0)),
          child: TextField(
            onChanged: (value) {
              initiateSearch(value);
            },
            autofocus: true,
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
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              if (tempSearchStore.length != 0)
                GridView.count(
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 1 / 1.25,
                    children: tempSearchStore.map((element) {
                      return buildResultJeans(element);
                    }).toList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultJeans(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                product: Product.fromFireStore(data),
              ),
            ));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: data['image'],
                child: CachedNetworkImage(
                  imageUrl:
                      "https://drive.google.com/thumbnail?id=${data['img']}&sz=w200-h200",
                ),
              ),
            ),
            Text(
              "${data['name']}",
            ),
            Text(
              "${data['price']}\$",
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
  }
}
