import 'package:flutter/material.dart';
import 'package:job/screen/LoginScreen.dart';

const List<Color> colorsList = [
  Colors.black54,
  Colors.greenAccent,
  Colors.blueGrey,
  Colors.green,
  Colors.indigo,
  Colors.orange,
  Colors.black54,
  Colors.white,
  Colors.white,
  Colors.white,

];

const String kBackgroundImage = 'images/background.jpg';
const kThemeColor = Colors.orange;
const String baseUrl = "http://d420c307eb47.ngrok.io";
const String kPasswordPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
const String kEmailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const String kConnexionProblemMessage = 'Maybe you need to turn on your wifi or mobile connexion';
const String kInternalError = 'Internal error';
const String kCheckEmailForOTPMessage = 'please check your email and press continue';