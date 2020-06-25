class AuthenticationDTO{

  AuthenticationDTO();

  String _username;
  String _password;

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

  AuthenticationDTO.fromJson(Map<String,dynamic> json)
    : _username = json['username'],
      _password = json['password'];

  Map<String, dynamic> toJson () =>
  {
      'username':this._username,
      'password':this._password
  };
}