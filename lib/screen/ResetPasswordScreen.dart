import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job/Constant.dart';
import 'package:job/component/Popup.dart';
import 'package:job/model/ResetPasswordDTO.dart';
import 'package:job/routes/SlideRightRoute.dart';
import 'package:job/screen/HomeScreen.dart';
import 'package:job/screen/LoadingScreen.dart';
import 'package:job/screen/LoginScreen.dart';
import 'package:job/service/NetworkHelper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  double loading = 100.0;
  bool isEnabled = true;
  NetworkHelper helper = NetworkHelper();
  ResetPasswordDTO resetPasswordDTO = ResetPasswordDTO();

  CustomTextField usernameTextField = CustomTextField(
    icon: Icons.card_travel,
    obscure: false,
    hint: 'Username',
    errorMessage: "Field can not be empty",
    enabled: true,
    maxLength: 20,
  );
  CustomTextField emailTextField = CustomTextField(
    icon: Icons.email,
    obscure: false,
    hint: 'Email',
    errorMessage: "Field can not be empty",
    emailErrorMessage: "please use à valid email",
    enabled: true,
    maxLength: 40,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(kBackgroundImage),
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.colorBurn),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'centerImage',
                  child: CenterImage(
                    height: (MediaQuery.of(context).size.width) / 2.1,
                    width: (MediaQuery.of(context).size.width) / 2.1,
                    size: (MediaQuery.of(context).size.width) / 2.1,
                    loading: loading,
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidate: this.validate,
                  child: Column(
                    children: <Widget>[
                      usernameTextField,
                      emailTextField,
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          margin: EdgeInsets.only(left: 25, right: 25),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.orange),
                            ),
                            elevation: 5.0,
                            animationDuration: Duration(seconds: 10),
                            splashColor: Colors.orangeAccent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 17,
                            ),
                            color: kThemeColor,
                            disabledColor: kThemeColor.withOpacity(0.8),
                            onPressed: isEnabled ? () => sendToServer() : null,
                            child: Container(
                              height: 25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeScreen() {
    Duration time = Duration(seconds: 5);
    Timer(
        time,
        () => Navigator.push(
              context,
              SlideRightRoute(
                page: LoadingScreen(),
              ),
            ));
  }

  void sendToServer() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        this.loading = null;
        this.isEnabled = false;
        usernameTextField.setEnabled(false);
        emailTextField.setEnabled(false);
      });
      resetPasswordDTO.setUsername(usernameTextField.getvalue());
      resetPasswordDTO.setEmail(emailTextField.getvalue());
      helper.setUrl('$baseUrl/my/pro/job/account/resetToken');
      String response = await helper.resetPassword(resetPasswordDTO);
      if (response == kCheckEmailForOTPMessage) {
        _changeScreen();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Popup(
                icon: Icons.check_circle,
                contentText: response,
                buttonText: 'Continue',
                todo: () => Navigator.push(
                  context,
                  SlideRightRoute(
                    page: LoadingScreen(),
                  ),
                ),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Popup(
                icon: Icons.highlight_off,
                contentText: response,
                buttonText: 'Retry',
                todo: () => Navigator.pop(context),
              );
            });
      }
      setState(() {
        this.loading = 100;
        this.isEnabled = true;
        this.usernameTextField.setEnabled(true);
        this.emailTextField.setEnabled(true);
      });
    } else {
      setState(() {
        this.validate = true;
      });
    }
  }
}
