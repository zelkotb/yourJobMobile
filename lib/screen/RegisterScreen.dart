import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job/Constant.dart';
import 'package:job/model/RegisterDTO.dart';
import 'package:job/screen/LoginScreen.dart';
import 'package:job/service/NetworkHelper.dart';
import 'package:job/utils/jwt.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

enum UserType {
  CANDIDATE,
  RECRUITER,
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double loading = 100;
  bool isEnabled = true;
  bool validate = false;
  UserType type = UserType.CANDIDATE;
  RegisterDTO registerDTO = RegisterDTO();
  NetworkHelper helper = NetworkHelper();

  final _formKey = GlobalKey<FormState>();
  CustomTextField usernameTextField = CustomTextField(
    icon: Icons.card_travel,
    obscure: false,
    hint: 'Username',
    errorMessage: "Field can not be empty",
    enabled: true,
    maxLength: 20,
  );
  CustomTextField passwordTextField = CustomTextField(
    icon: Icons.security,
    obscure: true,
    hint: 'Password',
    suffixIcon: Icons.remove_red_eye,
    errorMessage: "Field can not be empty",
    passwordErrorMessage: "please use a valid password",
    enabled: true,
    maxLength: 20,
  );
  CustomTextField repeatPasswordTextField = CustomTextField(
    icon: Icons.security,
    obscure: true,
    hint: 'Repeat Password',
    suffixIcon: Icons.remove_red_eye,
    errorMessage: "Field can not be empty",
    repeatPasswordErrorMessage: "Field must much Password Field",
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
                Hero(
                  tag: 'centerImage',
                  child: CenterImage(
                    height: 140.0,
                    width: 140.0,
                    left: 140.0,
                    size: 140.0,
                    loading: loading,
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidate: this.validate,
                  child: Column(
                    children: <Widget>[
                      usernameTextField,
                      passwordTextField,
                      repeatPasswordTextField,
                      emailTextField,
                      Container(
                        width: 400,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: ListTile(
                                title: Text(
                                  'Candidate',
                                  style: TextStyle(
                                    color: kThemeColor,
                                  ),
                                ),
                                leading: Radio(
                                  value: UserType.CANDIDATE,
                                  groupValue: type,
                                  activeColor: kThemeColor,
                                  onChanged: isEnabled
                                      ? (UserType value) {
                                          setState(() {
                                            type = value;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                            ),
                            Container(
                              width: 170,
                              child: ListTile(
                                title: Text(
                                  'Recruiter',
                                  style: TextStyle(
                                    color: kThemeColor,
                                  ),
                                ),
                                leading: Radio(
                                  value: UserType.RECRUITER,
                                  groupValue: type,
                                  activeColor: kThemeColor,
                                  onChanged: isEnabled
                                      ? (UserType value) {
                                          setState(() {
                                            type = value;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: kThemeColor),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendToServer() async {
    repeatPasswordTextField.setPasswordValue(passwordTextField.getvalue());
    if (_formKey.currentState.validate()) {
      setState(() {
        this.loading = null;
        this.isEnabled = false;
        this.usernameTextField.setEnabled(false);
        this.passwordTextField.setEnabled(false);
        this.emailTextField.setEnabled(false);
      });
      registerDTO.setUsername(this.usernameTextField.getvalue());
      registerDTO.setPassword(this.passwordTextField.getvalue());
      registerDTO.setEmail(this.emailTextField.getvalue());
      List<String> roles = List();
      String role = type.toString().substring(type.toString().indexOf('.') + 1);
      roles.add(role);
      registerDTO.setRoles(roles);
      helper.setUrl('$baseUrl/my/pro/job/account/register');
      var response = await helper.register(registerDTO);
      if (response == 'Internal error' || response['message'] != null) {
        ErrorResponse errorResponse = ErrorResponse();
        String message =
            response == 'Internal error' ? response : response['message'];
        errorResponse.setMessage(message);
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Something Went Wrong",
          desc: errorResponse.getMessage(),
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
        Alert(
          context: context,
          type: AlertType.success,
          title: "Congratulations",
          desc:
              "You have created your account successfully, Please check out your emails, and click on Done button to go to login screen",
          buttons: [
            DialogButton(
              color: Colors.green,
              child: Text(
                "Done",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ).show();
      }
      setState(() {
        this.loading = 100;
        this.isEnabled = true;
        this.usernameTextField.setEnabled(true);
        this.passwordTextField.setEnabled(true);
        this.emailTextField.setEnabled(true);
      });
    } else {
      setState(() {
        this.validate = true;
      });
    }
  }
}
