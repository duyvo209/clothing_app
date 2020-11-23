import 'package:duyvo/blocs/login/login_bloc.dart';
import 'package:duyvo/pages/HomePage.dart';
import 'package:duyvo/pages/LoginWithPhone.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:duyvo/pages/SignupPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String email = '';
  String password = '';
  bool isFirstTime = true;

  @override
  initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (_, state) {
        if (state.loginError.isNotEmpty) {
          showDialog(
              context: context,
              builder: (_) {
                return SimpleDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  children: [
                    Padding(
                      child: Text(state.loginError),
                      padding: EdgeInsets.only(left: 25, right: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: Container(
                        child: Icon(
                          Icons.close_outlined,
                          color: Colors.white,
                        ),
                        width: 10,
                      ),
                      color: Colors.blueGrey[800],
                    )
                  ],
                );
              });
        }
        if (state.loginSuccess) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new HomePage()));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.loginLoading,
          opacity: 0.5,
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
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
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Login".tr().toString(),
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 40),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Welcome to Duy Vo Store",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                                      Container(
                                        padding: EdgeInsets.all(9),
                                        child: TextField(
                                          controller: _emailController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              // hintText: "Email",
                                              labelText: "Email",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              errorText: _emailError()),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: TextField(
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                SignupPage()));
                                  },
                                  child: Text(
                                    "Create a new account".tr().toString(),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isFirstTime = false;
                                    });
                                    BlocProvider.of<LoginBloc>(context).add(
                                      Login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
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
                                        "Login".tr().toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                Text(
                                  "Continue with social media".tr().toString(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          BlocProvider.of<LoginBloc>(context)
                                              .add(
                                            LoginWithFacebook(),
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.blue[900]),
                                          child: Center(
                                            child: Text(
                                              "Facebook",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginWithPhone()));
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.blueGrey[800]),
                                          child: Center(
                                            child: Text(
                                              "Phone",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
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
      }),
    );
  }
}
