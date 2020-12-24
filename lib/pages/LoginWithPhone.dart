import 'package:duyvo/blocs/login_phone/login_phone_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:duyvo/pages/SignupPage.dart';
import 'package:duyvo/blocs/authencation/authencation_bloc.dart';

class LoginWithPhone extends StatefulWidget {
  @override
  _LoginWithPhoneState createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final _phoneController = TextEditingController();

  final _codeController = TextEditingController();

  LoginPhoneBloc _loginPhoneBloc;
  @override
  void initState() {
    _loginPhoneBloc =
        LoginPhoneBloc(BlocProvider.of<AuthencationBloc>(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginPhoneBloc, LoginPhoneState>(
      cubit: _loginPhoneBloc,
      listener: (_, state) {
        if (state.confirmCodeSuccess && state.userId.isEmpty) {
          //Case user exist
          Navigator.pop(context);
          Navigator.pop(context);
        }
        if (state.userId.isNotEmpty) {
          //Case new user
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => SignupPage(
                uid: state.userId,
              ),
            ),
          );
        }
        if (state.loginPhoneError.isNotEmpty) {
          Fluttertoast.showToast(msg: state.loginPhoneError);
        }
        if (state.cofirmCodeError.isNotEmpty) {
          Fluttertoast.showToast(msg: state.cofirmCodeError);
        }
        if (state.loginPhoneSuccess) {
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
                      _loginPhoneBloc
                          .add(VerifyCode(code: _codeController.text.trim()));
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          //Hide keyboard tap outside
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
            body: BlocBuilder<LoginPhoneBloc, LoginPhoneState>(
                cubit: _loginPhoneBloc,
                builder: (context, state) {
                  return LoadingOverlay(
                    color: Colors.black.withOpacity(0.5),
                    isLoading:
                        state.confirmCodeLoading || state.loginPhoneLoading,
                    progressIndicator: CircularProgressIndicator(),
                    child: SingleChildScrollView(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: Colors.grey[200])),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300])),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    hintText: "Mobile Number"),
                                controller: _phoneController,
                              ),
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
                                    _loginPhoneBloc.add(
                                        LoginPhone(phoneNumber: '+$phone'));
                                  },
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}
