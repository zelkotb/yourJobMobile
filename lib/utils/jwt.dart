import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job/Constant.dart';

class JwtUtil {

  static FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static String decodeJWTBody(String jwt){
    List<String> token = jwt.split('.');
    String normalizedSource = base64Url.normalize(token[1]);
    return utf8.decode(base64Url.decode(normalizedSource));
  }

  static Future<bool> ifAuthenticated() async {
    String jwt = await secureStorage.read(key: 'jwt');
    return jwt==null ? false : true;
  }

  static void logoutUser() async{
    secureStorage.delete(key: 'jwt');
  }

  static bool validatePassword(String password){
    RegExp regExp = new RegExp(kPasswordPattern);
    return regExp.hasMatch(password);
  }

  static bool validateEmail(String email){
    RegExp regExp = new RegExp(kEmailPattern);
    return regExp.hasMatch(email);
  }

  static bool validateRepeatPassword(String repeatPassword, String password){
    return repeatPassword==password ? true : false ;
  }
}