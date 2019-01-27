import 'package:flutter/material.dart' as ma;
import 'package:flutter/animation.dart' as an;

//
// https://flutter.io/docs/development/ui/animations/tutorial
void main() {
  print("Hello World!!");
  ma.runApp(ma.MaterialApp(
    home: LogoApp(),) );
}

class LogoApp extends ma.StatefulWidget {
  @override
  ma.State<ma.StatefulWidget> createState() {
    return LogoAppState();
  }
}


class LogoAppState extends ma.State<LogoApp>
  with ma.SingleTickerProviderStateMixin<LogoApp>{
  an.Animation<double> animation;
  an.AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = an.AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this);
    animation = an.Tween(begin: 0.0, end: 300.0).animate(controller);
    animation.addListener((){
      setState(() {
        print("xx");
      });
    });
    controller.forward();
  }

  @override
  ma.Widget build(ma.BuildContext context) {
    return ma.Center(
      child: ma.Container(
        margin: ma.EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: ma.FlutterLogo(),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}