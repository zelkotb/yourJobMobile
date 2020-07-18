import 'package:job/Constant.dart';

class FieldUtil {

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