class ResetPasswordDTO{
  String _username;
  String _email;

  String getUsername(){
    return this._username;
  }
  void setUsername(String username){
    this._username = username;
  }
  String getEmail(){
    return this._email;
  }
  void setEmail(String email){
    this._email = email;
  }

  Map<String,dynamic> toJson(){
    return {
      'username':this._username,
      'email':this._email
    };
  }

  fromJson(Map<String,dynamic> json){
    this._username = json['username'];
    this._email = json['email'];
  }
}