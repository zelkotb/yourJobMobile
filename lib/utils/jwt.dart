import 'dart:convert';

class JwtUtil {

  static String decodeJWTBody(String jwt){
    List<String> token = jwt.split('.');
    String normalizedSource = base64Url.normalize(token[1]);
    return utf8.decode(base64Url.decode(normalizedSource));
  }
}