import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/blocs/login/login_bloc.dart';
import 'package:duyvo/blocs/new_arrivals/new_arrivals_bloc.dart';
import 'package:duyvo/pages/CartPage.dart';
import 'package:duyvo/pages/SearchPage.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:duyvo/pages/CollectionPage.dart';
import 'package:duyvo/pages/DetailPage.dart';
import 'package:duyvo/pages/LoginPage.dart';
import 'package:duyvo/pages/TShirtPage.dart';
import 'package:duyvo/pages/ShirtPage.dart';
import 'package:duyvo/pages/JeansPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List bannerAdSlider = [
    "assets/br.jpg",
    "assets/private.jpg",
    "assets/decao.jpg"
  ];

  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  void _openEndDrawer() {
    drawerKey.currentState.openEndDrawer();
  }

  // void _closeEndDrawer() {
  //   Navigator.of(context).pop();
  // }

  // _initFirestore() async {
  //   await Firebase.initializeApp();
  //   Query query = FirebaseFirestore.instance.collection('users');
  //   query.firestore.doc('users/0773355662').snapshots().listen((event) {
  //     print("name: ${event.data()}");
  //   });
  // }

  void initState() {
    super.initState();
    BlocProvider.of<NewArrivalsBloc>(context).add(GetListNewArrival());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      key: drawerKey,
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
        leading: IconButton(
          onPressed: () {
            drawerKey.currentState.openDrawer();
          },
          icon: Icon(EvaIcons.menuOutline),
        ),
        actions: <Widget>[
          Badge(
            badgeContent: Text(
              '3',
              style: TextStyle(color: Colors.white),
            ),
            badgeColor: Colors.red[600],
            shape: BadgeShape.circle,
            position: BadgePosition.topStart(start: 25, top: 2.5),
            animationType: BadgeAnimationType.scale,
            child: IconButton(
              icon: Icon(EvaIcons.shoppingCartOutline),
              onPressed: _openEndDrawer,
            ),
          ),
        ],
      ),
      drawerEdgeDragWidth: 0,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              // LoadingOverlay(
              //     isLoading: state.loginLoading,
              //     child: state.user != null ? StreamBuilder() : Container());
              if (state.user != null) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(state.user.uid)
                        .snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.data != null) {
                        var data = snapshot.data;
                        return UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          accountEmail: Text(
                            "${data['email']}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          accountName: Text(
                            "${data['lastname']} ${data['firstname']}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          currentAccountPicture: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.asset(
                              "assets/duyvo.jpg",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    });
              }
              return Container();
            }),
            SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new HomePage()));
              },
              title: Text(
                "Home",
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(EvaIcons.homeOutline),
            ),
            SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                'Products',
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(EvaIcons.cubeOutline),
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new TShirtPage()));
                  },
                  title: Text(
                    "T-Shirt",
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(EvaIcons.arrowIosForwardOutline),
                  //Icon(),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ShirtPage()));
                  },
                  title: Text(
                    "Shirts",
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(EvaIcons.arrowIosForwardOutline),
                  //Icon(),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new JeansPage()));
                  },
                  title: Text(
                    "Jeans",
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(EvaIcons.arrowIosForwardOutline),
                  //Icon(),
                ),
              ],
            ),
            SizedBox(height: 11),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new CollectionPage()));
              },
              title: Text(
                "Collection",
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(EvaIcons.imageOutline),
              //Icon(),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                "About",
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(EvaIcons.infoOutline),
            ),
            SizedBox(height: 10),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state.user == null) {
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new LoginPage()));
                    },
                    title: Text(
                      "Login",
                      style: TextStyle(fontSize: 16),
                    ),
                    leading: Icon(EvaIcons.personOutline),
                    //Icon(),
                  );
                } else {
                  return ListTile(
                    onTap: () async {
                      BlocProvider.of<LoginBloc>(context).add(
                        LogOut(),
                      );
                      Navigator.pop(context, true);
                    },
                    title: Text(
                      "Logout",
                      style: TextStyle(fontSize: 16),
                    ),
                    leading: Icon(EvaIcons.personOutline),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(EvaIcons.settingsOutline),
              children: <Widget>[
                ExpansionTile(
                    title: Text(
                      'Theme',
                      style: TextStyle(fontSize: 16),
                    ),
                    leading: Icon(EvaIcons.bulbOutline),
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          // setState(() {
                          //   EasyLocalization.of(context).locale =
                          //       Locale('vi', 'Vi');
                          // });
                        },
                        title: Text(
                          "Light Theme",
                          style: TextStyle(fontSize: 16),
                        ),
                        leading: Icon(EvaIcons.arrowIosForwardOutline),
                        //Icon(),
                      ),
                      ListTile(
                        onTap: () {
                          // setState(() {
                          //   EasyLocalization.of(context).locale =
                          //       Locale('en', 'En');
                          // });
                        },
                        title: Text(
                          "Dark Theme",
                          style: TextStyle(fontSize: 16),
                        ),
                        leading: Icon(EvaIcons.arrowIosForwardOutline),
                        //Icon(),
                      ),
                    ]),
                ExpansionTile(
                    title: Text(
                      'Langueges',
                      style: TextStyle(fontSize: 16),
                    ),
                    leading: Icon(EvaIcons.globeOutline),
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          // setState(() {
                          //   EasyLocalization.of(context).locale =
                          //       Locale('vi', 'Vi');
                          // });
                        },
                        title: Text(
                          "Vietnamese",
                          style: TextStyle(fontSize: 16),
                        ),
                        leading: Icon(EvaIcons.arrowIosForwardOutline),
                        //Icon(),
                      ),
                      ListTile(
                        onTap: () {
                          // setState(() {
                          //   EasyLocalization.of(context).locale =
                          //       Locale('en', 'En');
                          // });
                        },
                        title: Text(
                          "English",
                          style: TextStyle(fontSize: 16),
                        ),
                        leading: Icon(EvaIcons.arrowIosForwardOutline),
                        //Icon(),
                      ),
                    ]),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 5,
                  child: Image.asset(
                    "assets/banner.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // const Text("This is the cart"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new CartPage()));
                },
                child: const Text('Cart'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
              ),
            ],
          ),
        ),
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ));
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search products ...",
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
                height: 20,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  autoPlay: true,
                ),
                items: bannerAdSlider.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image(
                            image: AssetImage(i),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: 19,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "New Arrivals",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<NewArrivalsBloc, NewArrivalsState>(
                  builder: (context, state) {
                return GridView.count(
                  physics: ClampingScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: 1 / 1.25,
                  children: state.newarrivals.map((product) {
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
                                      "https://drive.google.com/thumbnail?id=${product.image}&sz=w200-h200",
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
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
