import 'package:duyvo/blocs/register/register_bloc.dart';
import 'package:duyvo/pages/LoginPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

class SignupPage extends StatefulWidget {
  final String title = "Registration";
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypepasswordController =
      TextEditingController();

  bool isLoading = false;
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String retypepassword = '';
  String imageUser = '';
  bool isFirstTime = true;
  File _image;

  @override
  initState() {
    super.initState();
    _firstnameController.addListener(() {
      setState(() {
        firstname = _firstnameController.text;
      });
    });
    _lastnameController.addListener(() {
      setState(() {
        lastname = _lastnameController.text;
      });
    });
    _emailController.addListener(() {
      setState(() {
        email = _emailController.text;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        password = _passwordController.text;
      });
    });
    _retypepasswordController.addListener(() {
      setState(() {
        retypepassword = _retypepasswordController.text;
      });
    });
  }

  String _firstnameError() {
    if (isFirstTime) {
      return null;
    }
    if (firstname == '') {
      return 'Firstname is invalid';
    }
    return null;
  }

  String _lastnameError() {
    if (isFirstTime) {
      return null;
    }
    if (lastname == '') {
      return 'Lastname is invalid';
    }
    return null;
  }

  String _emailError() {
    if (isFirstTime) {
      return null;
    }
    if (EmailValidator.validate(email ?? '')) {
      return null;
    }
    return 'Email is invalid';
  }

  String _passwordError() {
    if (isFirstTime) {
      return null;
    }
    if (password.length < 6) {
      return 'Password is invalid';
    }
    return null;
  }

  String _retypepasswordError() {
    if (isFirstTime) {
      return null;
    }
    if (retypepassword == '' || retypepassword != password) {
      return 'Password incorrect';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image.path);
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask;
      var downloadUrl = await taskSnapshot.ref.getDownloadURL();
      String url = downloadUrl.toString();
      setState(() {
        print("Profile Picture uploaded");
      });
      return url;
    }

    return BlocListener<RegisterBloc, RegisterState>(listener: (_, state) {
      if (state.registerSuccess) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }, child: BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.registerLoading,
          opacity: 0.5,
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              // floatingActionButton: FloatingActionButton(onPressed: () async {
              //   await _getData();
              // }),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 0),
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                      Colors.grey[200],
                      Colors.grey[400],
                      Colors.grey[800]
                    ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Registration".tr().toString(),
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 40),
                          ),
                          SizedBox(height: 0),
                          Text(
                            "Welcome to Duy Vo Store",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60))),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 0,
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.center,
                                            child: CircleAvatar(
                                              radius: 75,
                                              backgroundColor: Colors.grey[300],
                                              child: ClipOval(
                                                child: new SizedBox(
                                                  width: 140.0,
                                                  height: 140.0,
                                                  child: (_image != null)
                                                      ? Image.file(
                                                          _image,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Image.asset(
                                                          "assets/noavt.png",
                                                          fit: BoxFit.fill,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 60.0),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.camera_alt,
                                                size: 30.0,
                                                color: Colors.blueGrey[700],
                                              ),
                                              onPressed: () {
                                                getImage();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: TextFormField(
                                          controller: _firstnameController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              // hintText: "First Name",
                                              labelText:
                                                  "First Name".tr().toString(),
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              errorText: _firstnameError()),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "keke";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: TextFormField(
                                          controller: _lastnameController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              // hintText: "Last Name",
                                              labelText:
                                                  "Last Name".tr().toString(),
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              errorText: _lastnameError()),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "keke";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        key: _formKey,
                                        padding: EdgeInsets.all(8),
                                        child: TextFormField(
                                          controller: _emailController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              // hintText: "Email",
                                              labelText: "Email",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              errorText: _emailError()),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "keke";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: TextFormField(
                                          obscureText: true,
                                          controller: _passwordController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              // hintText: "Password",
                                              labelText:
                                                  "Password".tr().toString(),
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              errorText: _passwordError()),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "keke";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: TextFormField(
                                          obscureText: true,
                                          controller: _retypepasswordController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              // hintText: "Retype Password",
                                              labelText: "Retype Password"
                                                  .tr()
                                                  .toString(),
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              errorText:
                                                  _retypepasswordError()),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "keke";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isFirstTime = false;
                                    });
                                    final url = await uploadPic(context);
                                    BlocProvider.of<RegisterBloc>(context)
                                        .add(Register(
                                      firstname: _firstnameController.text,
                                      lastname: _lastnameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      imageUser: url,
                                    ));
                                    uploadPic(context);
                                  },
                                  child: Container(
                                    height: 50,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        "Registration".tr().toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  // onTap: _register,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
