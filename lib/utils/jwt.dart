import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
}