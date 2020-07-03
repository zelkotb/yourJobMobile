import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:job/model/AuthenticationDTO.dart';
import 'package:job/model/RegisterDTO.dart';

class NetworkHelper {
  String _url;
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json"
  };

  void setUrl(String url) {
    this._url = url;
  }

  Future<dynamic> authenticate(AuthenticationDTO authenticationDTO) async {
    http.Response response;
    var jsonResponse;
    try {
      response = await http.post(
        this._url,
        headers: headers,
        body: jsonEncode(
          authenticationDTO.toJson(),
        ),
      );
      if (response.statusCode == 200) {
        jsonResponse = jsonDecode(response.body);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        jsonResponse = 'Username or Password incorrect';
      } else {
        jsonResponse = 'Internal error';
      }
    } catch (e) {
      print(e);
    }
    return jsonResponse;
  }

  Future<dynamic> register(RegisterDTO registerDTO) async {
    http.Response response;
    var jsonResponse;
    try {
      response = await http.post(this._url,
          headers: headers, body: jsonEncode(registerDTO.toJson()));
      if (response.statusCode == 201 || response.statusCode == 400) {
        jsonResponse = jsonDecode(response.body);
      } else {
        jsonResponse = 'Internal error';
      }
    } catch (e) {
      print(e);
    }
    return jsonResponse;
  }
}

class ErrorResponse {
  String message;

  void setMessage(String message){
    this.message = message;
  }
  String getMessage(){
    return this.message;
  }
}
