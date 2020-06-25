import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job/Constant.dart';
import 'package:job/model/AuthenticationDTO.dart';
import 'package:job/service/NetworkHelper.dart';
import 'package:job/utils/jwt.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  double loading = 100.0;
  bool isEnabled = true;
  final storage = FlutterSecureStorage();
  AuthenticationDTO authenticationDTO = AuthenticationDTO();
  CustomTextField usernameField = CustomTextField(
    icon: Icons.card_travel,
    obscure: false,
    hint: 'Username',
    errorMessage: "Field can not be empty",
    enabled: true,
  );
  CustomTextField passwordField = CustomTextField(
    icon: Icons.security,
    obscure: true,
    hint: 'Password',
    suffixIcon: Icons.remove_red_eye,
    errorMessage: "Field can not be empty",
    enabled: true,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.colorBurn),
          image: AssetImage('images/background.jpg'),
        ),
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
                CenterImage(
                  loading: loading,
                ),
                Form(
                  key: _formKey,
                  autovalidate: this.validate,
                  child: Column(
                    children: <Widget>[
                      usernameField,
                      passwordField,
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
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
                            width: 150,
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
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.black12,
                      animationDuration: Duration(seconds: 5),
                      splashColor: Colors.orangeAccent,
                      onPressed: () {},
                      child: Text(
                        'Forget Password',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                    ),
                    RaisedButton(
                      color: Colors.black12,
                      animationDuration: Duration(seconds: 5),
                      splashColor: Colors.orangeAccent,
                      onPressed: () {},
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendToServer() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        this.loading = null;
        this.isEnabled = false;
        usernameField.setEnabled(false);
        passwordField.setEnabled(false);
      });
      authenticationDTO.setUsername(usernameField.value);
      authenticationDTO.setPassword(passwordField.value);
      NetworkHelper helper = NetworkHelper();
      helper.setUrl('$baseUrl/my/pro/job/authenticate');
      var result = await helper.authenticate(authenticationDTO);
      if (result == 'Username or Password incorrect' ||
          result == 'Internal error') {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Something Went Wrong",
          desc: result,
          buttons: [
            DialogButton(
              color: kThemeColor,
              child: Text(
                "Retry",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ).show();
      } else {
        await storage.write(key: 'jwt', value: result['jwt']);
        String jsonBody = JwtUtil.decodeJWTBody(result['jwt']);
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        //prefs.setString('username', jsonBody['subject']);
        //prefs.setString('roles', jsonBody['roles']);
      }
      setState(() {
        this.loading = 100;
        this.isEnabled = true;
        usernameField.setEnabled(true);
        passwordField.setEnabled(true);
      });
    } else {
      this.validate = true;
    }
    ;
  }
}

class CenterImage extends StatelessWidget {
  double loading;
  CenterImage({this.loading});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 100,
          child: Container(
            height: 200.0,
            width: 200.0,
            child: CircularProgressIndicator(
              backgroundColor: Colors.black38,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
              value: loading,
            ),
          ),
        ),
        Positioned(
          left: 100,
          child: Container(
            child: Icon(
              Icons.account_circle,
              color: kThemeColor,
              size: 200,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: -12,
                  blurRadius: 5,
                )
              ],
              shape: BoxShape.circle,
            ),
          ),
        ),
        Container(
          height: 220.0,
          width: 210.0,
          child: Text(''),
        ),
      ],
    );
  }
}

class CustomTextField extends StatefulWidget {
  IconData icon;
  bool obscure;
  String hint;
  IconData suffixIcon;
  String errorMessage;
  GlobalKey<FormState> key;
  String value;
  bool enabled;

  String getvalue() {
    return this.value;
  }

  void setEnabled(bool enabled) {
    this.enabled = enabled;
  }

  CustomTextField(
      {this.icon,
      this.obscure,
      this.hint,
      this.suffixIcon,
      this.errorMessage,
      this.key,
      this.enabled});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  IconData icon;
  bool obscure;
  String hint;
  IconData suffixIcon;
  String errorMessage;
  GlobalKey<FormState> key;
  bool enabled;

  @override
  void initState() {
    super.initState();
    icon = widget.icon;
    obscure = widget.obscure;
    hint = widget.hint;
    suffixIcon = widget.suffixIcon;
    errorMessage = widget.errorMessage;
    enabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black12,
        )
      ]),
      child: TextFormField(
        enabled: enabled,
        obscureText: obscure,
        maxLength: 20,
        cursorColor: kThemeColor,
        cursorRadius: Radius.circular(10.0),
        cursorWidth: 5.0,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return this.errorMessage;
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            widget.value = value;
          });
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.red[400], fontSize: 15),
          helperText: 'mandatory *',
          helperStyle: TextStyle(
            color: kThemeColor,
          ),
          hintText: this.hint,
          hintStyle: TextStyle(
            color: Colors.orange.withOpacity(0.7),
          ),
          counterStyle: TextStyle(
            color: kThemeColor,
          ),
          suffixIcon: FlatButton(
            padding: EdgeInsets.only(left: 50),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              setState(() {
                this.obscure = this.obscure == false ? true : false;
              });
            },
            child: Icon(
              this.suffixIcon,
              color: kThemeColor,
              size: 25,
            ),
          ),
          prefixIcon: Icon(
            this.icon,
            color: kThemeColor,
            size: 30,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: kThemeColor,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 5,
              color: kThemeColor,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.red[400],
            ),
          ),
        ),
      ),
    );
  }
}
