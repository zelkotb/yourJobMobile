import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job/screen/HomeScreen.dart';
import 'package:job/screen/LoginScreen.dart';
import 'dart:ui' as ui;

import 'package:job/utils/jwt.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  Color colorCircle2 = Colors.white;
  Color colorCircle3 = Colors.white;
  Color colorCircle4 = Colors.white;
  Color iconColor = Colors.transparent;
  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 3,
  );
  AnimationController _controller;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    animationTimer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController = AnimationController(vsync:this,duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation =  Tween(begin: 1.0,end: 10.0).animate(_animationController)..addListener((){
      setState(() {

      });
    });
  }

  Future<void> animationTimer() async {
    Duration duration2 = Duration(milliseconds: 1000);
    Duration duration3 = Duration(milliseconds: 1500);
    Duration duration4 = Duration(milliseconds: 2000);
    Duration duration5 = Duration(milliseconds: 2500);
    Duration duration6 = Duration(milliseconds: 4000);
    Duration duration7 = Duration(milliseconds: 7000);
    Duration duration8 = Duration(seconds: 9);
    Timer(duration2, () => changeColor2());
    Timer(duration3, () => changeColor3());
    Timer(duration4, () => changeColor4());
    Timer(duration5, () => changeIconColor());
    Timer(duration6, () => changeAnimation('f'));
    Timer(duration7, () => changeAnimation('r'));
    Timer(duration8, () => changeScreen());
  }

  void changeAnimation(String type){
    if(type == 'f'){
      setState(() {
        _controller.forward();
      });
    }else{
      _controller.reverse();
    }

  }
  void changeColor2() async {
    setState(() {
      colorCircle2 = Colors.orange[400];
    });
  }

  void changeColor3() async {
    setState(() {
      colorCircle3 = Colors.orange[200];
    });
  }

  void changeColor4() async {
    setState(() {
      colorCircle4 = Colors.orange[100];
    });
  }

  void changeIconColor() async {
    setState(() {
      iconColor = Colors.orange[200];
    });
  }

  void changeScreen() async {
    JwtUtil.logoutUser();
    bool ifAuthenticated = await JwtUtil.ifAuthenticated();
    if (ifAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: _animation.value,
                      spreadRadius: 1,
                    )
                  ]),
              child: FlatButton(
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.orange[600],
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: colorCircle2,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: colorCircle3,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: colorCircle4,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white70,
                          child: Icon(
                            Icons.business_center,
                            size: 70,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            RotationTransition(
              turns: turnsTween.animate(_controller),
              child: Container(
                width: 300,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Y',
                        style: TextStyle(
                          foreground: Paint()
                            ..shader = ui.Gradient.linear(
                              const Offset(0, 20),
                              const Offset(250, 25),
                              <Color>[
                                Colors.red,
                                Colors.orangeAccent,
                              ],
                            ),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DancingScript',
                          fontSize: 70,
                        ),
                        children: [
                          TextSpan(
                            text: 'our',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: ' J',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: 'ob',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
