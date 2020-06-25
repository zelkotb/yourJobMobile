import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:job/model/AuthenticationDTO.dart';

class NetworkHelper {
  String _url;

  void setUrl(String url) {
    this._url = url;
  }

  Future<dynamic> authenticate(AuthenticationDTO authenticationDTO) async {
    http.Response response;
    var jsonResponse;
    try {
      response = await http.post(
        this._url,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode(
          authenticationDTO.toJson(),
        ),
      );
      if (response.statusCode == 200) {
        print("200");
        jsonResponse = jsonDecode(response.body);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        print("400");
        jsonResponse = 'Username or Password incorrect';
      } else {
        print("500");
        jsonResponse = 'Internal error';
      }
    } catch (e) {
      print(e);
    }
    return jsonResponse;
  }
}
