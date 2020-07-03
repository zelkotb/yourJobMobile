import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job/Constant.dart';
import 'package:job/screen/HomeScreen.dart';
import 'package:job/screen/LoginScreen.dart';
import 'package:job/utils/jwt.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  double top1 = 300;
  double top2 = 150;
  double top3 = 450;
  double top4 = 300;
  double left1 = 0;
  double left2 = 165;
  double left3 = 165;
  double left4 = 330;
  AnimationController controller;
  AnimationController controller2;

  Position calculatePosition(double top, double left) {
    if (top > 150 && top <= 300 && left >= 0 && left < 165) {
      top = top - controller.value.toInt();
      left = left + controller2.value.toInt();
    } else if (top >= 150 && top < 300 && left < 330 && left >= 165) {
      top = top + controller.value.toInt();
      left = left + controller2.value.toInt();
    } else if (top >= 300 && top < 450 && left <= 330 && left > 165) {
      top = top + controller.value.toInt();
      left = left - controller2.value.toInt();
    } else if (top > 300 && top <= 450 && left > 0 && left <= 165) {
      top = top - controller.value.toInt();
      left = left - controller2.value.toInt();
    }
    Position position = Position(top, left);
    return position;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 150.0,
    );
    controller2 = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 165.0,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    controller2.forward();
    controller2.addListener(() {
      setState(() {});
    });
    controller.repeat(period: Duration(seconds: 1));
    controller2.repeat(period: Duration(seconds: 1));
    animationTimer();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  void animationTimer() async {
    Duration sec = Duration(seconds: 10);
    Timer(
      sec,
      () => changeScreen(),
    );
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

  List<Positioned> getLoadingImages() {
    List<Positioned> images = [];
    images.add(
      Positioned(
        top: calculatePosition(top1, left1).getTop(),
        left: calculatePosition(top1, left1).getLeft(),
        child: LoadingImage(
          icon: Icons.assignment_ind,
        ),
      ),
    );
    images.add(
      Positioned(
        top: calculatePosition(top2, left2).getTop(),
        left: calculatePosition(top2, left2).getLeft(),
        child: LoadingImage(
          icon: Icons.assignment_turned_in,
        ),
      ),
    );
    images.add(
      Positioned(
        top: calculatePosition(top3, left3).getTop(),
        left: calculatePosition(top3, left3).getLeft(),
        child: LoadingImage(
          icon: Icons.print,
        ),
      ),
    );
    images.add(
      Positioned(
        top: calculatePosition(top4, left4).getTop(),
        left: calculatePosition(top4, left4).getLeft(),
        child: LoadingImage(
          icon: Icons.phone,
        ),
      ),
    );
    images.add(
      Positioned(
        top: 300,
        left: 165,
        child: Container(
          child: LoadingImage(
            icon: Icons.card_travel,
          ),
        ),
      ),
    );
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white10,
        child: Stack(
          children: getLoadingImages(),
        ),
      ),
    );
  }
}

class LoadingImage extends StatefulWidget {
  int colorIndex1 = 0;
  int colorIndex2 = 5;
  IconData icon;

  LoadingImage({
    this.icon,
  });
  @override
  _LoadingImageState createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage> {
  int colorIndex1;
  int colorIndex2;
  IconData icon;

  @override
  void initState() {
    icon = widget.icon;
    colorIndex1 = widget.colorIndex1;
    colorIndex2 = widget.colorIndex2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        setState(() {
          if (colorIndex2 < colorsList.length - 1) {
            ++colorIndex1;
            ++colorIndex2;
          } else {
            colorIndex1 = 0;
            colorIndex2 = 5;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 1),
        padding: EdgeInsets.all(20),
        child: Icon(
          icon,
          color: colorsList[colorIndex2],
          size: 40,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
          boxShadow: [
            BoxShadow(
              color: colorsList[colorIndex1],
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

class Position {
  Position(this.top, this.left);

  double top;
  double left;

  double getTop() {
    return this.top;
  }

  double getLeft() {
    return this.left;
  }
}
