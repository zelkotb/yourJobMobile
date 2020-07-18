import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:job/Constant.dart';
import 'package:job/model/AuthenticationDTO.dart';
import 'package:job/model/RegisterDTO.dart';
import 'package:job/model/ResetPasswordDTO.dart';

class NetworkHelper {
  String _url;
  Map<String, String> _headers = {
    HttpHeaders.contentTypeHeader: "application/json"
  };

  void setUrl(String url) {
    this._url = url;
  }

  Future<bool> _verifyReachability() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }

  Future<http.Response> postWithoutToken(dynamic objectDTO) async {
    return http.post(
      this._url,
      headers: _headers,
      body: jsonEncode(
        objectDTO.toJson(),
      ),
    );
  }

  Future<dynamic> authenticate(AuthenticationDTO authenticationDTO) async {
    http.Response response;
    var jsonResponse;
    try {
      if (await _verifyReachability()) {
        response = await postWithoutToken(authenticationDTO);
        if (response.statusCode == 200) {
          jsonResponse = jsonDecode(response.body);
        } else if (response.statusCode >= 400 && response.statusCode < 500) {
          jsonResponse = 'Username or Password incorrect';
        } else {
          jsonResponse = kInternalError;
        }
      } else {
        jsonResponse = kConnexionProblemMessage;
      }
    } catch (e) {
      print(e);
      jsonResponse = kInternalError;
    }
    return jsonResponse;
  }

  Future<dynamic> register(RegisterDTO registerDTO) async {
    http.Response response;
    var jsonResponse;
    try {
      if (await _verifyReachability()) {
        response = await postWithoutToken(registerDTO);
        if (response.statusCode == 201 || response.statusCode == 400) {
          jsonResponse = jsonDecode(response.body);
        } else {
          jsonResponse = kInternalError;
        }
      } else {
        jsonResponse = kConnexionProblemMessage;
      }
    } catch (e) {
      print(e);
      jsonResponse = kInternalError;
    }
    return jsonResponse;
  }

  Future<dynamic> resetPassword(ResetPasswordDTO resetPasswordDTO) async {
    http.Response response;
    var jsonResponse;
    try {
      if (await _verifyReachability()) {
        response = await postWithoutToken(resetPasswordDTO);
        print(response.statusCode);
        if (response.statusCode == 201) {
          jsonResponse = kCheckEmailForOTPMessage;
        }
        else if (response.statusCode == 401) {
          jsonResponse = jsonDecode(response.body)['message'];
        } else {
          jsonResponse = kInternalError;
        }
      } else {
        jsonResponse = kConnexionProblemMessage;
      }
    } catch (e) {
      print(e);
      jsonResponse = kInternalError;
    }
    return jsonResponse;
  }
}

class ErrorResponse {
  String message;

  void setMessage(String message) {
    this.message = message;
  }

  String getMessage() {
    return this.message;
  }
}
