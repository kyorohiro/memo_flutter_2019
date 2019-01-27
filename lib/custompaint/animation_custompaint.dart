import 'package:flutter/material.dart' as ma;
import 'package:flutter/animation.dart' as an;
import 'dart:ui' as ui;
import 'package:flutter/services.dart' as sv;
import 'package:flutter/painting.dart' as pa;
import 'dart:async';
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
      });
    });
    animation.addStatusListener((an.AnimationStatus status){
      print("> ${status}");
      if(status == an.AnimationStatus.completed) {
            controller.reverse();
      } else if(status == an.AnimationStatus.dismissed){
            controller.forward();
      }
    });
    controller.forward();
  }

  @override
  ma.Widget build(ma.BuildContext context) {
    return ma.Center(
      child: ma.CustomPaint(
          foregroundPainter: Custom(animation.value, animation.value),
          size: ma.Size(animation.value, animation.value),
          isComplex: true,
          willChange:  true,
      )
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}



class Custom extends ma.CustomPainter {
  double w;
  double h;
  Custom(this.w,this.h){;}
  @override
  void paint(ma.Canvas canvas, ma.Size size) {
    ui.Paint paint = ui.Paint();
    paint.color = ui.Color.fromARGB(255, 255, 120, 120);
    canvas.drawRect(ui.Rect.fromLTWH(0,0,w,h), paint);
  }

  @override
  bool shouldRepaint(ma.CustomPainter oldDelegate) {
    return true;
  }

}




class ImageLoader {

  static sv.AssetBundle getAssetBundle() => (sv.rootBundle != null) ? sv.rootBundle : new sv.NetworkAssetBundle(new Uri.directory(Uri.base.origin));

  static Future<ui.Image> load(String url) async {
    pa.ImageStream stream = new pa.AssetImage(url, bundle: getAssetBundle()).resolve(pa.ImageConfiguration.empty);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    void listener(pa.ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    }
    stream.addListener(listener);
    return completer.future;
  }
}