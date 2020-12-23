import 'package:duyvo/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:international_phone_input/international_phone_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duyvo/pages/SignupPage.dart';

// ignore: must_be_immutable
class LoginWithPhone extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  Future loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          UserCredential result = await _auth.signInWithCredential(credential);

          User user = result.user;
          //  await FirebaseFirestore.instance
          //     .collection('users')
          //     .doc(data.user.uid)
          //     .set({
          //   'firstname': data.user.displayName,
          //   'lastname': '',
          //   'email': data.user.email,
          //   'imageUser': data.user.photoURL,
          // });

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          print("code: $verificationId");
          Fluttertoast.showToast(msg: 'Please check you message box');

          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.black,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        // ignore: deprecated_member_use
                        AuthCredential credential =
                            // ignore: deprecated_member_use
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);

                        UserCredential result =
                            await _auth.signInWithCredential(credential);

                        User user = result.user;

                        if (user != null) {
                          var data = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .get();
                          if (data.exists == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  user: user,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(
                                  uid: user.uid,
                                  isRegisterWithPhone: true,
                                ),
                              ),
                            );
                          }
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  String phoneNumber;
  String phoneIsoCode;
  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Login",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey[300])),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: "Mobile Number"),
                controller: _phoneController,
              ),
              // InternationalPhoneInput(
              //   decoration: InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(8)),
              //           borderSide: BorderSide(color: Colors.grey[200])),
              //       focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(8)),
              //           borderSide: BorderSide(color: Colors.grey[300])),
              //       filled: true,
              //       fillColor: Colors.grey[100],
              //       hintText: "Mobile Number"),
              //   onPhoneNumberChange: onPhoneNumberChange,
              //   initialPhoneNumber: phoneNumber,
              //   initialSelection: 'VN',
              //   showCountryCodes: true,
              // ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("LOGIN"),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(16),
                  onPressed: () {
                    final phone = _phoneController.text.trim();
                    loginUser('+$phone', context);
                  },
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void setState(Null Function() param0) {}
}
