import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job/Constant.dart';
import 'package:job/model/AuthenticationDTO.dart';
import 'package:job/routes/SlideLeftRoute.dart';
import 'package:job/routes/SlideRightRoute.dart';
import 'package:job/screen/HomeScreen.dart';
import 'package:job/screen/RegisterScreen.dart';
import 'package:job/screen/ResetPasswordScreen.dart';
import 'package:job/service/NetworkHelper.dart';
import 'package:job/utils/Field.dart';
import 'package:job/utils/jwt.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    JwtUtil.logoutUser();
    super.initState();

  }

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
    maxLength: 20,
  );
  CustomTextField passwordField = CustomTextField(
    icon: Icons.security,
    obscure: true,
    hint: 'Password',
    suffixIcon: Icons.remove_red_eye,
    errorMessage: "Field can not be empty",
    enabled: true,
    maxLength: 20,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.colorBurn),
            image: AssetImage(kBackgroundImage),
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
                  Hero(
                    tag: 'centerImage',
                    child: CenterImage(
                      height: (MediaQuery.of(context).size.width)/2.1,
                      width: (MediaQuery.of(context).size.width)/2.1,
                      size: (MediaQuery.of(context).size.width)/2.1,
                      loading: loading,
                    ),
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
                          child: Container(
                            margin: EdgeInsets.only(left:25,right: 25),
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.black12,
                        animationDuration: Duration(seconds: 5),
                        splashColor: Colors.orangeAccent,
                        onPressed: isEnabled
                            ? () => navigateToPage(ResetPasswordScreen(),'right')
                            : null,
                        child: Text(
                          'Forget Password',
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width)/3,
                        height: 50,
                      ),
                      RaisedButton(
                        color: Colors.black12,
                        animationDuration: Duration(seconds: 5),
                        splashColor: Colors.orangeAccent,
                        onPressed: isEnabled
                            ? () => navigateToPage(RegisterScreen(),'left')
                            : null,
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
      ),
    );
  }

  navigateToPage(Widget widget, String direction) {
    if(direction=='left'){
      Navigator.push(context, SlideLeftRoute(page: widget));
    }
    if(direction=='right'){
      Navigator.push(context, SlideRightRoute(page: widget));
    }
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
          result == kInternalError || result == kConnexionProblemMessage) {
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var decodedJsonBody = jsonDecode(jsonBody);
        List<dynamic> dynamicRoles = decodedJsonBody['roles'];
        List<String> roles = dynamicRoles.map((dr) => dr.toString()).toList();
        prefs.setString('username', decodedJsonBody['subject']);
        prefs.setStringList('roles', roles);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
      setState(() {
        this.loading = 100;
        this.isEnabled = true;
        usernameField.setEnabled(true);
        passwordField.setEnabled(true);
      });
    } else {
      setState(() {
        this.validate = true;
      });
    }
  }
}

class CenterImage extends StatelessWidget {
  double loading;
  double height;
  double width;
  double size;
  CenterImage({
    this.loading,
    this.height,
    this.width,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: (((MediaQuery.of(context).size.width)/2)-(width/2)),
          child: Container(
            height: height,
            width: width,
            child: CircularProgressIndicator(
              backgroundColor: Colors.black38,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
              value: loading,
            ),
          ),
        ),
        Positioned(
          left: (((MediaQuery.of(context).size.width)/2)-(width/2)),
          child: Container(
            child: Icon(
              Icons.account_circle,
              color: kThemeColor,
              size: size,
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
          height: height + 30,
          width: width + 30,
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
  String passwordErrorMessage;
  String emailErrorMessage;
  String repeatPasswordErrorMessage;
  String passwordValue;
  GlobalKey<FormState> key;
  String value;
  bool enabled;
  int maxLength;

  String getvalue() {
    return this.value;
  }

  void setPasswordValue(String passwordValue){
    this.passwordValue = passwordValue;
  }
  String getPasswordValue(){
    return this.passwordValue;
  }
  void setEnabled(bool enabled) {
    this.enabled = enabled;
  }

  CustomTextField({
    this.icon,
    this.obscure,
    this.hint,
    this.suffixIcon,
    this.errorMessage,
    this.key,
    this.enabled,
    this.maxLength,
    this.passwordErrorMessage,
    this.emailErrorMessage,
    this.repeatPasswordErrorMessage,
    this.passwordValue,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  IconData icon;
  bool obscure;
  String hint;
  IconData suffixIcon;
  String errorMessage;
  String passwordErrorMessage;
  String emailErrorMessage;
  String repeatPasswordErrorMessage;
  GlobalKey<FormState> key;
  bool enabled;
  int maxLength;

  @override
  void initState() {
    super.initState();
    icon = widget.icon;
    obscure = widget.obscure;
    hint = widget.hint;
    suffixIcon = widget.suffixIcon;
    errorMessage = widget.errorMessage;
    enabled = widget.enabled;
    maxLength = widget.maxLength;
    passwordErrorMessage = widget.passwordErrorMessage;
    emailErrorMessage = widget.emailErrorMessage;
    repeatPasswordErrorMessage = widget.repeatPasswordErrorMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10,left: 25,right: 25,),
      padding: EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: 5,
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black12,
        )
      ]),
      child: TextFormField(
        enabled: enabled,
        obscureText: obscure,
        maxLength: maxLength,
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
          else if (hint == 'Password') {
            if (!FieldUtil.validatePassword(value)) {
              return this.passwordErrorMessage;
            }
          }
          else if (hint == 'Email') {
            if (!FieldUtil.validateEmail(value)) {
              return this.emailErrorMessage;
            }
          }
          else if (hint == 'Repeat Password') {
              if(!FieldUtil.validateRepeatPassword(value, widget.getPasswordValue())){
                return this.repeatPasswordErrorMessage;
              }
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            widget.value = value;
          });
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Colors.red[400],
            fontSize: 15,
          ),
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
              if (this.suffixIcon != null) {
                setState(() {
                  this.obscure = this.obscure == false ? true : false;
                });
              }
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

