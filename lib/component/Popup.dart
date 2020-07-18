import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job/Constant.dart';

class Popup extends StatelessWidget {

  String contentText;
  IconData icon;
  Function todo;
  String buttonText;

  Popup({this.buttonText,this.contentText,this.icon,this.todo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      title: Text(
        'Change Password',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  icon,
                  color: kThemeColor,
                  size: 150,
                ),
              ),
            ),
            SizedBox(height: 0.0),
            Container(
              alignment: Alignment.center,
              height: 45.0,
              child: Text(
                contentText,
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: FlatButton(
                onPressed: todo,
                color: kThemeColor,
                child: Text(buttonText,style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
