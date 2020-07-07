import 'package:job/model/AuthenticationDTO.dart';

class RegisterDTO{
  String _username;
  String _password;
  String _email;
  List<String> roles;

  String getUsername(){
    return this._username;
  }

  void setUsername(String username){
    this._username = username;
  }

  String getPassword(){
    return this._password;
  }

  void setPassword(String password){
    this._password = password;
  }

  String getEmail(){
    return this._email;
  }

  void setEmail(String email){
    this._email = email;
  }

  List<String> getRoles(){
    return this.roles;
  }

  void setRoles(List<String> roles){
    this.roles = roles;
  }

  Map<String, dynamic> toJson (){
    return {
      'username' : this._username,
      'password' : this._password,
      'email' : this._email,
      'roles' : this.roles,
    };
  }

  RegisterDTO fromJson(Map<String,dynamic> json){
    this._username = json['username'];
    this._password = json['password'];
    this._email = json['email'];
    this.roles = json['roles'];
    return this;
  }
}